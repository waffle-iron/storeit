import shared
import client
from log import logger

last_transport = None

#JOIN username port file_json_object
def JOIN(data):

    params = data.split(' ', 2)
    username, port, json = params[0], params[1], params[2]

    shared.climanager.add_cli(username, port, json, last_transport)


def parse(command: str, transport):

    global last_transport
    last_transport = transport

    command_split = command.split(' ', 1)

    cmds = {'JOIN': JOIN}

    cmds[command_split[0]](command_split[1])

def FUPDATE(tree, client):
    client.send_cmd('FUPDATE {}'.format(tree))

def FADD(tree, client):
    client.send_cmd('FADD {}'.format(tree))

def CHSEND(from_cli, to_cli, send: int, chk: str):

    addr = to_cli.transport.get_extra_info('peername')
    if addr == None:
        logger.error('could not get ip for user {}'.format(to_cli.username))

    addr_and_port = addr[0] + ':' + to_cli.port
    from_cli.send_cmd('CHSEND {} {} {}'.format(send, chk, addr_and_port))
