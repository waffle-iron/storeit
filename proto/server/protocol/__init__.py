import shared
import engine
import database
import json
import chunk
from common.log import logger

last_transport = None


# JOIN username port file_json_object
def JOIN(client, data):
    username, port, hashes, json = data.split(' ', 3)

    client = shared.climanager.add_cli(username, port, json, last_transport)

    if hashes != 'None':
        chunk.add_user(client, hashes.split(':'))


def parse(command: str, transport):
    global last_transport
    last_transport = transport

    command_split = command.split(' ', 1)

    cmds = {'JOIN': JOIN,
            'FADD': FADD,
            'FUPDATE': FUPDATE,
            'FDELETE': FDELETE}

    asked_cmd = command_split[0]

    if asked_cmd not in cmds:
        logger.error('unknown command {}'.format(asked_cmd))

    client = None
    client_name = str()
    if transport in shared.climanager.transports:
        client_name = shared.climanager.transports[transport]
        client = shared.climanager.clients[client_name]

    if client is None and asked_cmd != 'JOIN':
        logger.error("""no client has been found for this connection and """
                     """command {}. Refusing to continue""".format(command))
        return

    cmds[asked_cmd](client, command_split[1])


def FDELETE(client, cmds):
    logger.warn('unimplemented FDELETE')
    pass


def FADD(client, cmds):
    tr = json.loads(cmds)

    directory, filename = client.find_in_tree(tr)

    engine.FADD(directory, 'client', filename, tr, client)

    logger.info('new user tree has been saved for {}'.format(client.username))
    database.save_new_tree(client.username, client.user_tree.raw_tree)


def FUPDATE(client, cmds):
    tr = json.loads(cmds)

    # TODO: catch exception
    # TODO: remove the unused chunk
    # TODO: don't use engine.FADD, find something more elegant

    directory, filename = client.find_in_tree(tr)

    engine.FADD(directory, 'client', filename, tr, client)


def send_FUPDATE(tree, client):
    if type(tree) == dict:
        tree = json.dumps(tree)

    client.send_cmd('FUPDATE {}'.format(tree))


def send_FADD(tree, client):
    if type(tree) == dict:
        tree_json = json.dumps(tree)

    client.send_cmd('FADD {}'.format(tree_json))
    # TODO: wait for response

    if tree['kind'] != 0:
        engine.send_chunk_to(client, tree['unique_hash'])


def send_CHDELETE(client, chk):
    client.send_cmd('CHDELETE ' + chk)


def send_CHSEND(from_cli, to_cli, send: int, chk: str):
    addr = to_cli.transport.get_extra_info('peername')
    if addr is None:
        logger.error('could not get ip for user {}'.format(to_cli.username))

    addr_and_port = addr[0] + ':' + to_cli.port
    from_cli.send_cmd('CHSEND {} {} {}'.format(send, chk, addr_and_port))
