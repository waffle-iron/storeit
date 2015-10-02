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
        this.data = {};
        this.file = CONFIG_FILES.default;
        try
        {
            fs.accessSync(CONFIG_FILES.user, fs.R_OK | fs.W_OK);
            this.file = CONFIG_FILES.user;
        }
        catch (e)
        {
            console.info('Could not open user configuration,' +
            ' switching to default configuration.');
        }
        finally
        {
            let path = `${__dirname}/${this.file}`;
            Object.assign(this.data, JSON.parse(fs.readFileSync(path, 'utf8')));
            console.log(JSON.stringify(this.data));
        }
    }

    save()
    {
        let path = `${__dirname}/${CONFIG_FILES.user}`;
        fs.writeFileSync(path, JSON.stringify(this.data));
    }

}
