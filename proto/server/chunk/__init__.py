from log import logger
import shared

chunks = dict()
users = dict()

def add_user(username: str, hashes: list):
    for h in hashes:
        register_chunk(h, username)

def get_chunk_owners(chunk: str):
    return [shared.climanager.get_cli(name) for name in chunks[chunk]]

def has_user_chunk(chunk: str, username: str):
    if not chunk in chunks:
        return []
    return username in chunks[chunk]

def register_chunk(chunk: str, username: str):
    if not chunk in chunks:
        chunks[chunk] = [username]
    else:
        chunks[chunk].append(username)

    if not username in users:
        users[username] = [chunk]
    else:
        users[username].append(chunk)

def remove_user(username: str):
    if not username in users:
        logger.debug('user {} has zero chunks'.format(username))
        return

    for chunk in users[username]:
        chunks[chunk].remove(username)

    del users[username]

def remove_chunk(chunk: str):
    if not chunk in chunks:
        logger.debug('chunk {} does not exists'.format(chunk))

    for user in chunks[chunk]:
        users[user].remove(chunk)

    del chunks[chunk]
