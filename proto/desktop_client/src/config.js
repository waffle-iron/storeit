'use strict';
import * as fs from 'fs';

const CONFIG_FILES = {
    default: 'data/config_dfl.json',
    user: 'data/config_usr.json'
};


export default class Config
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        this.file = CONFIG_FILES.default;
        try
        {
            fs.accessSync(CONFIG_FILES.user, fs.R_OK | fs.W_OK);
            this.file = CONFIG_FILES.user;
        }
        catch (e) {}
        finally
        {
            let configVals =
                JSON.parse(fs.readFileSync(`./dist/${this.file}`, 'utf8'));
            Object.assign(this, configVals);
            console.log(JSON.stringify(this));
        }
    }

}
