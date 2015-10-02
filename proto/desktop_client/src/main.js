#! /usr/bin/env node
'use strict';

import * as fs from 'fs';

GLOBAL.config = null;

function   configLoad()
{
    let fileCheck = (path) => fs.accessSync(path, fs.R_OK | fs.W_OK);

    try
    {
        fileCheck('data/config_usr');
    }
    catch (e)
    {
        console.log(e);
    }
}

configLoad();
