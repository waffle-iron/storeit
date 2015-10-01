#! /usr/bin/env node
'use strict';

import * as fs from 'fs';

let fd = fs.openSync('./toto', 'w+');
fs.writeSync(fd, 'hello world');
