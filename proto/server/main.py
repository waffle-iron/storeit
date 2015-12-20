#! /usr/bin/env python3

import network
import sys
import logging
import test
from log import logger

logger.setLevel(logging.DEBUG)

if sys.argv[1] == 'test':
    test.all()
    exit(0)


netmanager = network.NetManager()
netmanager.loop()
