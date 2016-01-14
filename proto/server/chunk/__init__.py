from log import logger
import shared
import engine

chunks = dict()
users = dict()

def add_user(username: str, hashes: list):

    logger.debug('{} has {} chunks to register'.format(username, len(hashes)))

    for h in hashes:
        if h == '':
            logger.warn('{} sent invalid chunk hash'.format(username))
            continue
        register_chunk(h, username)
        keep_chunk_alive(h)

def get_chunk_owners(chk: str):
    if not chk in chunks:
        return []
    return [shared.climanager.get_cli(name) for name in chunks[chk]]

#TODO: add an availability flag to know if the client is available
def get_chunk_owner(chk: str):
    if not chk in chunks or chunks[chk] == []:
        return None
    return shared.climanager.get_cli(chunks[chk][0])

def has_user_chunk(chk: str, username: str):
    if not chk in chunks:
        return []
    return username in chunks[chk]

def register_chunk(chk: str, username: str):
    if not chk in chunks:
        chunks[chk] = [username]
    else:
        chunks[chk].append(username)

    if not username in users:
        users[username] = [chk]
    else:
        users[username].append(chk)


def remove_user(username: str):
    if not username in users:
        logger.debug('user {} has zero chunks'.format(username))
        return

    for chk in users[username]:
        chunks[chk].remove(username)
        keep_chunk_alive(chk)

    del users[username]

def remove_chunk(chk: str):
    if not chk in chunks:
        logger.debug('chunk {} does not exists'.format(chk))
        return

    for user in chunks[chk]:
        users[user].remove(chk)

    del chunks[chk]

def get_redundancy(chk: str):

    if chk not in chunks:
        return 0
    return len(chunks[chk])

def dump():
    logger.debug('dump chunks:'.format(chunks))
    logger.debug('dump users:'.format(users))

def find_user_for_storing(chk: str):

    for u in shared.climanager.clients.keys():
        if not has_user_chunk(chk, u):
            return shared.climanager.get_cli(u)
    return None

def keep_chunk_alive(chk: str):
    
    redundancy = get_redundancy(chk)

    #TODO: do some multicast propagation for chunk hosting
    while redundancy < 6:
        engine.host_chunk(chk)
        redundancy += 1
