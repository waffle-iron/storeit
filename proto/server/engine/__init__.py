import protocol
import chunk
import shared
from log import logger

def FADD(directory, from_who, filename, tree, client):

    logger.debug('user {} adding {} from {}'.format(client.username, tree['path'], from_who))

    if from_who == 'server':
        protocol.send_FADD(tree, client)
    elif tree['kind'] != 0:
        chunk.register_chunk(tree['unique_hash'], client.username)
        chunk.keep_chunk_alive(tree['unique_hash'])
    else:
        pass #TODO: handle adding a directory with some content

    directory[filename] = tree

def FUPDATE(new_tree, from_who, old_tree, client):
    
    if from_who == 'server':
        protocol.send_FUPDATE(new_tree, client)
        if new_tree['kind'] != 0:
            send_chunk_to(client, new_tree['unique_hash'])

    if from_who == 'client' and old_tree['kind'] != 0:
        #FIXME: it will happen that some clients share identical chunks,
        # do not do this
        make_chunk_disappear(old_tree['unique_hash'])
        chunk.keep_chunk_alive(new_tree['unique_hash'])

    old_tree['unique_hash'] = new_tree['unique_hash']


def make_chunk_disappear(chk: str):

    owners = chunk.get_chunk_owners(chk)

    for o in owners:
        protocol.send_CHDELETE(o, chk)

    chunk.remove_chunk(chk) 

def send_chunk_to(client, chk):

    from_cli = chunk.get_chunk_owner(chk)
    if from_cli == None:
        logger.warn('could not find any user hosting {}'.format(chk))
        return

    logger.debug('{} is being sent from {} to {}'.format(chk, from_cli.username, client.username))
    protocol.send_CHSEND(from_cli, client, 1, chk)
    protocol.send_CHSEND(client, from_cli, 0, chk)
    chunk.register_chunk(chk, client.username)

def host_chunk(chk):

    user = chunk.find_user_for_storing(chk)

    if user == None:
        logger.warn('could not find any user to store {}'.format(chk))
        return

    send_chunk_to(user, chk)
