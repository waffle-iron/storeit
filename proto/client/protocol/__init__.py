import tree
import chunk
import json
import hashlib
import network

from common import log
from common.log import logger


def parse(cmd: str):

    command_split = cmd.split(b' ', 1)

    class Command:

        def __init__(self, fcall, isstr):
            self.function_call = fcall
            self.is_string = isstr

    cmds = {b'FADD': Command(FADD, True),
            b'FUPDATE': Command(FUPDATE, True),
            b'CHSEND': Command(CHSEND, True),
            # TODO: rethink the hole stuff
#            b'CHSTORE': Command(CHSTORE, False),
            b'CHDELETE': Command(CHDELETE, True)}

    logger.info(log.nomore('somebody sent {}'.format(cmd)))

    content = command_split[1]
    cmd = cmds[command_split[0]]
    if cmd.is_string:
        content = content.decode()

    cmds[command_split[0]].function_call(content)


def CHDELETE(params):

    chk = params[0]

    chunk.remove_chunk(chk)


def send_FCMD(name, tree):

    # FIXME: remove this quickfix
    if json.dumps(tree).find('DS_Store') != -1:
        return

    network.send_cmd('{} {}'.format(name, json.dumps(tree)))


def send_FDELETE(path):
    network.send_cmd('FDELETE {}'.format(path))


def FADD(params):

    tr = json.loads(params)
    tree.make_file(tr)


def FUPDATE(params):
    pass


def CHSEND(params):
    send, hsh, addr = params.split(' ', 3)

    ip, port = addr.split(':')
    if send == '1':
        logger.info('sending chunk {} to {} on port {}'.format(hsh, ip, port))
        send_CHSTORE(ip, int(port), hsh)
    else:
        logger.info('getting chunk {} from {}'.format(hsh, ip))
        pass  # TODO


def CHSTORE(data):

    logger.debug('CHSTORE for {} bytes'.format(len(data)))

    # TODO: store only if we are waiting for it
    hasher = hashlib.sha256()
    hasher.update(data)
    chk = hasher.hexdigest()

    if chk in chunk.chunk_awaiting:
        with open(chunk.chunk_awaiting[chk], "wb") as file:
            file.write(data)
        del chunk.chunk_awaiting[chk]
    else:
        chunk.store_chunk(chk, data)


def send_CHSTORE(ip, port, hsh):

    path = chunk.get_path_for_chunk(hsh)

    if path is None:
        logger.error('chunk {} could not be found'.format(hsh))

    try:
        data = open(path, 'rb').read()
    except:
        logger.error('cannot read file {}'.format(path))
        return

    if data is None:
        logger.error('file read returned None')
        return

    network.send_payload(ip, port, 'CHSTORE {} '.format(len(data)), data)


def login(client):

    json_tree = tree.usertree
    my_chks = list(chunk.my_chunks.keys())
    my_store = []  # TODO: later read the content of .store

    hashes = 'None' if len(my_chks) == 0 else ':'.join(my_chks + my_store)

    network.send_cmd('JOIN {} {} {} {}'
                     .format(client.username, client.port,
                             hashes, json.dumps(json_tree)))
