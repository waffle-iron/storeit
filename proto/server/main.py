#! /usr/bin/env python3

import database
import subprocess
import network
import sys
import logging
import test
from log import logger

logger.setLevel(logging.DEBUG)

if len(sys.argv) > 1 and sys.argv[1] == 'test':
    test.all()
    exit(0)

database.__init__()
try:
  print(database.find_user('maoizejf', 'maoziejf'))
except AttributeError:
  logger.warn('Looks like postgres daemon is not running. It will be started')
  #subprocess.call("")
  database.__init__()

netmanager = network.NetManager()
netmanager.loop()
