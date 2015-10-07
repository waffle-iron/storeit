#! /usr/bin/env node

'use strict';
import 'source-map-support/register';
import * as storeit from './storeit';

new storeit.Client()
    .readUserInput();
