#! /usr/bin/env node

'use strict';
import 'source-map-support/register';
import * as storeit from './storeit';

global.config = new storeit.Config();

new storeit.Client()
    .readUserInput();
global.config.save();
