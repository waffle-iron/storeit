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
        this.data = {};
        let file = Config.exists() ? CONFIG_FILES.usr : CONFIG_FILES.dfl;
        let fd = fs.readFileSync(`${__dirname}/${file}`, 'utf8');
        Object.assign(this.data, JSON.parse(fd));
        this.valid = true;

        if (file === CONFIG_FILES.dfl)
        {
            this.init();
        }
    }

    save()
    {
        let path = `${__dirname}/${CONFIG_FILES.usr}`;
        fs.writeFileSync(path, JSON.stringify(this.data));
    }

    init()
    {
        for (let [key, text] of this.STEPS)
        {
            this.valid = false;
            while (!this.valid)
            {
                let question = `${text}: `;
                if (this.showDefault(key))
                    question += `[${this[key]}]`;
                this[key] = readlineSync.question(question);
            }
        }
    }

    showDefault(key)
    {
        return key !== 'password' && this.data[key] != null;
    }

    static exists()
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

    set server(ip)
    {
        this.data.server = ip;
        this.valid = true;
    }

    get server()
    {
        return this.data.server;
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
    ['server', 'Server IP address'],
    ['port', 'Server port'],
    ['username', 'Username'],
    ['password', 'Password'],
    ['root', 'Folder path'],
]);

Config.prototype.STEPS = STEPS;
