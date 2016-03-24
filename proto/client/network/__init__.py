import asyncio
import protocol
import threading
import socket

from common.log import logger

server_transport = None
receivers = list()


class Receiver():

    def __init__(self, transport):
        self.transport = transport


class Network():

    data_buffer = bytes()

    def data_received(self, data):
        self.data_buffer += data


class Server(Network):

    def connection_made(self, transport):
        receivers.append(Receiver(transport))

    def data_received(self, data):

        super.data_received(data)

        commands = self.data_buffer.split(b"\r\n")
        self.data_buffer = commands[-1]
        commands = commands[:-1]

        for cmd in commands:
            protocol.parse(cmd)

waiting_for_command = True


class Client(Network):

    def __init__(self, loop, port, username):
        self.loop = loop
        self.port = port
        self.username = username
        self.byte_count = 0

    def connection_made(self, transp):

        global server_transport

        server_transport = transp
        protocol.login(self)

    def data_received(self, data):

        super.data_received(data)

        if self.byte_count > 0:
            self.byte_count -= len(data)
            if self.byte_count <= 0:
                protocol.CHSTORE(self.data_buffer)

        else:
            commands = self.data_buffer.split(b"\r\n")
            self.data_buffer = commands[-1]
            commands = commands[:-1]

            for cmd in commands:
                protocol.parse(cmd)

    def connection_lost(self, exc):
        logger.error('The server closed the connection')
        logger.info('Stop the event loop')
        self.loop.stop()


def send_cmd(msg):
    logger.debug('cmd: ' + msg)

    msg += '\r\n'
    server_transport.write(msg.encode())


def listen(port):
    eloop = asyncio.new_event_loop()
    asyncio.set_event_loop(eloop)

    coro = eloop.create_server(Server, '127.0.0.1', port)
    server = eloop.run_until_complete(coro)

    logger.info('listening on {}'.format(server.sockets[0].getsockname()))
    try:
        eloop.run_forever()
    except KeyboardInterrupt:
        pass

    server.close()
    eloop.run_until_complete(server.wait_closed())
    eloop.close()
    exit(0)


def loop(username, client_port, server_port=7641):
    thread = threading.Thread(target=listen, args=(client_port,))
    thread.daemon = True
    thread.start()

    loop = asyncio.get_event_loop()
    coro = loop.create_connection(lambda: Client(loop, client_port, username),
                                  '127.0.0.1', server_port)
    try:
        loop.run_until_complete(coro)
        loop.run_forever()
    except KeyboardInterrupt:
        pass

    loop.close()


def send_payload(ip: str, port: int, cmd: str, data: bytes):

    logger.info('sending {}'.format(cmd))
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((ip, port))

    # TODO: something memory efficient
    final = cmd.encode() + data + '\r\n'.encode()
    sock.send(final)
