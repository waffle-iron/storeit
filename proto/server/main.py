#! /usr/bin/env python3

import database
import subprocess
import network
import sys
import logging
import test
import time
from common.log import logger

logger.setLevel(logging.DEBUG)

if len(sys.argv) > 1 and sys.argv[1] == 'test':
    test.all()
    exit(0)

try:
  database.__init__()
  database.find_user('maoizejf', 'maoziejf')
except Exception:
  logger.warn('Looks like postgres daemon is not running. It will be started')
  subprocess.call("./database/postgre.sh")
  time.sleep(0.2)
  database.__init__()

netmanager = network.NetManager()
netmanager.loop()
