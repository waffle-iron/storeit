import asyncio
import shared
import protocol
import traceback

from common.log import logger


class NetManager(asyncio.Protocol):

    data_buffer = str()
    transp = None

    def __init__(self):
        pass

    def connection_made(self, transport):
        self.transp = transport

    def connection_lost(self, ext):
        try:
            username = shared.climanager.transports[self.transp]
            del shared.climanager.clients[username]
            del shared.climanager.transports[self.transp]
            logger.info('{} has disconnected'.format(username))
        except KeyError:
            logger.info('connection with some unidentified client lost')

    # TODO: implement the fact that a command could be split in multiple data
    def data_received(self, data):

        data_left = data

        while len(data_left) > 0:

            parsed = data_left.split(b' ', 2)

            if len(parsed) < 2:
                logger.warn('invalid command {}'.format(data_left))
                return

            cmd = parsed[0]
            size = parsed[1]
            args = parsed[2]

            size_int = int(size.decode())

            if size_int < len(args):
                args = args[:size_int]
                data_left = args[size_int:]
            else:
                data_left = bytes()

            try:
                logger.info("{} {}".format(cmd, size))
                protocol.parse(cmd, size, args, self.transp)
            except Exception as e:
                logger.error('{} was raised'.format(e))
                for l in traceback.format_tb(e.__traceback__):
                    logger.debug(l)
                raise e

    def loop(self):

        loop = asyncio.get_event_loop()

        # Each client connection will create a new protocol instance
        coro = loop.create_server(NetManager, '0', 7641)
        server = loop.run_until_complete(coro)

        # Serve requests until Ctrl+C is pressed
        logger.info('Serving on {}'.format(server.sockets[0].getsockname()))
        try:
                loop.run_forever()
        except KeyboardInterrupt:
                print('KeyboardInterrupt')
                pass

        try:
            # Close the server
            server.close()
            loop.run_until_complete(server.wait_closed())
            loop.close()

        except KeyboardInterrupt:
            logger.warn('ok, nevermind')
            exit(1)
