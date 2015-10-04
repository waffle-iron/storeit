#! /usr/bin/env node

'use strict';
import 'source-map-support/register';
import Config from './config';

GLOBAL.config = new Config();

GLOBAL.config.save();
