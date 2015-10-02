#! /usr/bin/env node
'use strict';
import 'source-map-support/register';
import * as fs from 'fs';

const CONFIG_FILES = {
    default: 'data/config_dfl.json',
    user: 'data/config_usr.json'
};

GLOBAL.config = null;

function   configLoad()
{
    let fileLoad = (file) =>
    {
        GLOBAL.config =
            JSON.parse(fs.readFileSync(`./dist/${file}`, 'utf8'));
        console.log(GLOBAL.config);

        // run init
    };

    fs.access(CONFIG_FILES.user, fs.R_OK | fs.W_OK, (err) =>
        err ? fileLoad(CONFIG_FILES.default) : fileLoad(CONFIG_FILES.user));
}


configLoad();
