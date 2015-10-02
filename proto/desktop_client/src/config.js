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
        let file = CONFIG_FILES.default;
        try
        {
            let path = `${__dirname}/${CONFIG_FILES.user}`;
            fs.accessSync(path + file, fs.R_OK | fs.W_OK);
            file = CONFIG_FILES.user;
        }
        catch (e)
        {
            console.info('Could not open user configuration,' +
            ' switching to default configuration.');
        }
        finally
        {
            let fd = fs.readFileSync(`${__dirname}/${file}`, 'utf8');
            Object.assign(this.data, JSON.parse(fd));
            console.log(JSON.stringify(this.data));
        }
    }

    save()
    {
        let path = `${__dirname}/${CONFIG_FILES.user}`;
        fs.writeFileSync(path, JSON.stringify(this.data));
    }

}
