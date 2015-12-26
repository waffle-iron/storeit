import asyncio
import protocol
import threading
import socket

server_transport = None
receivers = list()

class Receiver():

    def __init__(self, transport):
        self.transport = transport

class Server(asyncio.Protocol):

    data_buffer = str()

    def __init_(self):
        pass

    def connection_made(self, transport):
        receivers.append(Receiver(transport))

    def data_received(self, data):

        message = data.decode()
        self.data_buffer += data.decode()
        commands = self.data_buffer.split("\r\n")
        self.data_buffer = commands[-1]
        commands = commands[:-1]

        for cmd in commands:
            protocol.parse(cmd)

    def loop(self, port):

        loop = asyncio.get_event_loop()

        # Each client connection will create a new protocol instance
        coro = loop.create_server(NetManager, '127.0.0.1', port)
        server = loop.run_until_complete(coro)

        # Serve requests until Ctrl+C is pressed
        logger.info('Serving on {}'.format(server.sockets[0].getsockname()))
        try:
                loop.run_forever()
        except KeyboardInterrupt:
                pass

        try:
            # Close the server
            server.close()
            loop.run_until_complete(server.wait_closed())
            loop.close()

        except KeyboardInterrupt:
            logger.warn('ok, nevermind')
            exit(1)




class Client(asyncio.Protocol):

    data_buffer = str()

    def __init__(self, loop, port, username):
        self.loop = loop
        self.port = port
        self.username = username
    
    def connection_made(self, transp):

        global server_transport

        server_transport = transp
        protocol.login(self)
    
    def data_received(self, data):

        message = data.decode()
        self.data_buffer += data.decode()
        commands = self.data_buffer.split("\r\n")
        self.data_buffer = commands[-1]
        commands = commands[:-1]

        for cmd in commands:
            protocol.parse(cmd)
    
    def connection_lost(self, exc):
        print('The server closed the connection')
        print('Stop the event loop')
        self.loop.stop()

def send_cmd(msg):
    print('cmd: ' + msg)

    msg += '\r\n'
    server_transport.write(msg.encode())

def listen(port):

    eloop = asyncio.new_event_loop()
    asyncio.set_event_loop(eloop)

    coro = eloop.create_server(Server, '127.0.0.1', port)
    server = eloop.run_until_complete(coro)

    print('listening on {}'.format(server.sockets[0].getsockname()))
    try:
        eloop.run_forever()
    except KeyboardInterrupt:
        pass

    server.close()
    eloop.run_until_complete(server.wait_closed())
    eloop.close()
    exit(0)

def loop(username, client_port, server_port = 7641):

    thread = threading.Thread(target=listen, args = (client_port,))
    thread.start()

    loop = asyncio.get_event_loop()
    coro = loop.create_connection(lambda: Client(loop, client_port, username),
                                  '127.0.0.1', server_port)
    loop.run_until_complete(coro)
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass

    loop.close()
    exit(0)


def send_payload(ip: str, port: int, cmd: str, data: bytes):

    print('sending {}'.format(cmd))
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((ip, port))

    #TODO: something memory efficient
    final = cmd.encode() + data + '\r\n'.encode()
    sent = sock.send(final)

