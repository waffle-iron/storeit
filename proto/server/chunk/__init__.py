"""Handle the chunk (stored/sent pieces of a file)."""

from common.log import logger
from common.hash import Hash
import shared
import engine

chunks = dict()
users = dict()


def add_user(who, hashes: list):

    logger.debug('{} has {} chunks to register'.
                 format(who.username, len(hashes)))

    for h in hashes:
        if h == '':
            logger.warn('{} sent invalid chunk hash'.format(who.username))
            continue
        h = Hash(h)
        register_chunk(h, who.username)
        keep_chunk_alive(who, h)


def get_chunk_owners(chk: Hash):
    if chk not in chunks:
        return []
    return [shared.climanager.get_cli(name) for name in chunks[chk]]


# TODO: add an availability flag to know if the client is available
def get_chunk_owner(chk: Hash):
    if chk not in chunks or chunks[chk] == []:
        return None
    return shared.climanager.get_cli(list(chunks[chk])[0])  # FIXME: ugly


def has_user_chunk(chk: Hash, username: str):
    if chk not in chunks:
        return []
    return username in chunks[chk]


def register_chunk(chk, username: str):

    logger.debug("registering chunk {} for {}".format(chk, username))

    if isinstance(chk, str):
        chk = Hash(chk)

    # TODO: use smart dict

    if chk not in chunks:
        chunks[chk] = {username}
    else:
        chunks[chk].add(username)

    if username not in users:
        users[username] = {chk}
    else:
        users[username].add(chk)

    dump()
    return chk


def remove_user(frm):

    if frm.username not in users:
        logger.debug('user {} has zero chunks'.format(frm.username))
        return

    for chk in users[frm.username]:
        chunks[chk].remove(frm.username)
        keep_chunk_alive(frm, chk)

    del users[frm.username]


def remove_chunk(chk: str):
    if chk not in chunks:
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

    for user, chks in users.items():
        logger.debug('user {} has {}'
                     .format(user, tuple(c.pretty() for c in chks))) # TODO: use builtin istead of comprehension
    for chks, usrs in chunks.items():
        logger.debug('chk {} is owned by {}'.format(chks.pretty(), usrs))


def find_user_for_storing(chk: Hash):
    for u in shared.climanager.clients.keys():
        if not has_user_chunk(chk, u):
            return shared.climanager.get_cli(u)
    return None


def keep_chunk_alive(frm, chk: Hash):
    redundancy = get_redundancy(chk)

    REDUNDANCY_LEVEL = 3

    # TODO: do some multicast propagation for chunk hosting
    while redundancy < REDUNDANCY_LEVEL:
        engine.host_chunk(frm, chk)
        redundancy += 1
