#! /usr/bin/env python3

import tree.fs
import network
import sys
from watchdog.observers import Observer  

if len(sys.argv) < 2:
    print('usage ./main.py username [listening port]')
    exit(1)

port = 7642
username = sys.argv[1]
storage_dir = tree.root

if len(sys.argv) > 2:
    port = int(sys.argv[2])

try:
    observer = Observer()
    observer.schedule(tree.fs.WatchFs(), storage_dir)
    observer.start()

    network.loop(username, port)
except ConnectionRefusedError:
    print('error: connection refused')

