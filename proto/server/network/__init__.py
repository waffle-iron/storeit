import asyncio
import shared
import re
import client
import protocol

from log import logger

class NetManager(asyncio.Protocol):

    data_buffer = str()
    transp = None

    def __init__(self):
        pass

    def connection_made(self, transport):
        self.transp = transport

    def data_received(self, data):

        message = data.decode()
        self.data_buffer += data.decode()
        commands = self.data_buffer.split("\r\n")
        self.data_buffer = commands[-1]
        commands = commands[:-1]

        for cmd in commands:
            protocol.parse(cmd, self.transp)

    def loop(self):

        loop = asyncio.get_event_loop()

        # Each client connection will create a new protocol instance
        coro = loop.create_server(NetManager, '127.0.0.1', 7641)
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

if __name__ == '__main__':
    print('testing...')
