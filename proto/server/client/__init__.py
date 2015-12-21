from log import logger
import tree
import database
import json

class Client:

    username = str()
    port = str()
    user_tree = None
    transport = None

    def __init__(self, username: str, port: str, tree: tree.Tree, transport):

        logger.info('{} has joined on port {}'.format(username, port))

        self.username = username
        self.port = port
        self.user_tree = tree
        self.transport = transport

    def send_cmd(self, msg):
        logger.debug('to {}: {}'.format(self.username, msg))

        if self.transport == None:
            logger.error('client has no transport registered')
            return

        msg += '\r\n'
        self.transport.write(msg.encode())
    
class CliManager:

    clients = dict()

    def __init__(self):
        pass

    def add_cli(self, username: str, port: str, tree_sent: str, transport):

        tree_database = database.find_user(username, 'zulu')

        if tree_database is None:
            logger.info('user {} does not exists'.format(username))
            return

        ts = tree.Tree(tree_sent)
        td = tree.Tree(tree_database)

        cli = Client(username, port, ts, transport)

        self.clients[username] = cli

        tree.Tree.process_subtree(cli, ts.raw_tree, td.raw_tree)

        logger.debug('tree has been processed for {}'.format(username))

        database.save_new_tree(username, ts.raw_tree)

        logger.debug(self.clients)


    def get_cli(self, username: str):

        if not username in self.clients:
            return None

        return self.clients[username]
