#! /usr/bin/env node

'use strict';
import 'source-map-support/register';
import * as storeit from './storeit';

let client = new storeit.Client();

client.readUserInput();
