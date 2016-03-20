#! /usr/bin/env python3

import tree.fs
import network
import chunk
import os
from watchdog.observers import Observer
from common.log import logger
import logging
import argparse

parser = argparse.ArgumentParser(description='StoreIt client backend.')
parser.add_argument('username', metavar='username', help='client username')
parser.add_argument('-l', '--log', nargs='?', const=True,
                    help='log to a file')
parser.add_argument('-p', '--port', type=int, default=7642,
                    help='port for p2p contact (default 7642).')
parser.add_argument('-f', '--files', default=tree.root,
                    help='set file storage directory')
parser.add_argument('-s', '--store', default='.storeit',
                    help='set the .storeit storage directory')

args = parser.parse_args()
print(args)

port = args.port
username = args.username
storage_dir = args.files
chunk.store_name = args.store

if args.log is not None:
    if type(args.log) is bool:
        args.log = '/tmp/' + username + '-' + str(port) + '.log'
    logging.basicConfig(filename=args.log, level=logging.DEBUG)

try:
    os.remove('.DS_Store')
except:
    logger.debug('no ds store')
    pass

try:
    observer = Observer()
    observer.schedule(tree.fs.WatchFs(), storage_dir, recursive=True)

    observer.start()

    network.loop(username, port)

except ConnectionRefusedError:
    logger.error('error: connection refused')
