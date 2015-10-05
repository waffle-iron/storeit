'use strict';
import * as fs from 'fs';
import * as readlineSync from 'readline-sync';

const CONFIG_FILES = {
    dfl: '../data/config_dfl.json',
    usr: '../data/config_usr.json'
};

export default class Config
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        let file = this.fileExists() ? CONFIG_FILES.usr : CONFIG_FILES.dfl;
        this.loadFromFile(file);
        this.valid = true;

        if (file === CONFIG_FILES.dfl)
        {
            this.data.root = Config.userHome() + '/storeit';
            this.init();
        }
    }

    save()
    {
        let path = `${__dirname}/${CONFIG_FILES.usr}`;
        fs.writeFileSync(path, JSON.stringify(this.data));
    }

    loadFromFile(file)
    {
        let fd = fs.readFileSync(`${__dirname}/${file}`, 'utf8');
        this.data = {};
        Object.assign(this.data, JSON.parse(fd));
    }

    reset()
    {
        let resp = '';
        while (resp !== 'yes' && resp !== 'no')
        {
            let question = 'Do you really want to reset configuration' +
                'to its default ?\n[Yes/No]: ';
            resp = readlineSync.question(question).trim().toLowerCase();
        }
        if (resp === 'yes')
        {
            this.loadFromFile(CONFIG_FILES.dfl);
        }
    }

    init()
    {
        let showDefault = (key) =>
        {
            return key !== 'password' && this.data[key] != null;
        };

        for (let [key, text] of this.STEPS)
        {
            this.valid = false;
            while (!this.valid)
            {
                let question = `${text}: `;
                if (showDefault(key))
                    question += `[${this[key]}]`;
                this[key] = readlineSync.question(question).trim();
            }
        }
    }

    fileExists()
    {
        try
        {
            let path = `${__dirname}/${CONFIG_FILES.usr}`;
            fs.accessSync(path, fs.R_OK | fs.W_OK);
        }
        catch (e)
        {
            console.info('StoreIt configuration not set.');
            return false;
        }
        return true;
    }

    static userHome()
    {
        return process.env.HOME || process.env.USERPROFILE;
    }

    set host(ip)
    {
        this.data.host = ip;
        this.valid = true;
    }

    get host()
    {
        return this.data.host;
    }

    set port(num)
    {
        this.data.port = num;
        this.valid = true;
    }

    get port()
    {
        return this.data.port;
    }

    set username(name)
    {
        this.data.username = name;
        this.valid = true;
    }

    get username()
    {
        return this.data.username;
    }

    set password(pass)
    {
        this.data.password = pass;
        this.valid = true;
    }

    get password()
    {
        return this.data.password;
    }

    set root(path)
    {
        this.data.root = path;
        this.valid = true;
    }

    get root()
    {
        return this.data.root;
    }
}

const STEPS = new Map([
    ['host', 'Server IP address'],
    ['port', 'Server port'],
    ['username', 'Username'],
    ['password', 'Password'],
    ['root', 'Folder path'],
]);

Config.prototype.STEPS = STEPS;
