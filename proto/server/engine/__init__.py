import protocol
import chunk
import shared
from log import logger

def FADD(directory, from_who, filename, tree, client):

    logger.debug('user {} adding {} from {}'.format(client.username, tree['path'], from_who))

    if from_who == 'server':
        protocol.FADD(tree, client)
    elif tree['kind'] != 0:
        chunk.register_chunk(tree['unique_hash'], client.username)
        chunk.keep_chunk_alive(tree['unique_hash'])
        chunk.dump()

    directory[filename] = tree

def FUPDATE(new_tree, from_who, old_tree, client):
    
    if client is not None:
        protocol.FUPDATE(new_tree, client)

    old_tree['unique_hash'] = new_tree['unique_hash']

def host_chunk(chk):

    user = chunk.find_user_for_storing(chk)

    if user == None:
        logger.warn('could not find any user to store {}'.format(chk))
        return

    from_cli = chunk.get_chunk_owner(chk)
    if from_cli == None:
        logger.warn('could not find any user hosting {}'.format(chk))
        return

    logger.debug('{} is being sent from {} to {}'.format(chk, from_cli.username, user.username))
    protocol.CHSEND(from_cli, user, 1, chk)
    protocol.CHSEND(user, from_cli, 0, chk)
    chunk.register_chunk(chk, user.username)
