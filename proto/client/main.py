#! /usr/bin/env python3

import tree.fs
import network
import sys
import chunk
import os
from watchdog.observers import Observer
from common.log import logger
import logging

logger.setLevel(logging.DEBUG)

try:
    os.remove('.DS_Store')
except:
    logger.debug('no ds store')
    pass

if len(sys.argv) < 2:
    print('usage ./main.py username [listening port] [store dir]')
    exit(1)

port = 7642
username = sys.argv[1]
storage_dir = tree.root

if len(sys.argv) >= 4:
    chunk.store_name = sys.argv[3]

if len(sys.argv) > 2:
    port = int(sys.argv[2])

try:
    observer = Observer()
    observer.schedule(tree.fs.WatchFs(), storage_dir, recursive=True)
    observer.start()

    network.loop(username, port)
except ConnectionRefusedError:
    logger.error('error: connection refused')
