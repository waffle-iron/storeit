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

        // if (file === CONFIG_FILES.dfl)
        // {
        //     this.init();
        // }
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

    init(nl=false)
    {
        for (let [field, text] of this.STEPS)
        {
            this.valid = false;
            while (!this.valid)
            {
                this.question(field, text, nl);
            }
        }
    }

    question(field, text, nl)
    {
        let showDefault = (field) => {
            return field !== 'password' && this.data[field] != null;
        };

        let questStr = text;
        if (field !== 'root')
            questStr += ': ';
        if (showDefault(field))
            questStr += `[${this.data[field]}]`;
        this[field] = readlineSync.question(questStr).trim();

        if (nl) console.log('');
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
        if (ip && ip.length)
            this.data.host = ip;
        this.valid = true;
    }

    get host()
    {
        return this.data.host;
    }

    set port(num)
    {
        if (num && num.length)
            this.data.port = num;
        this.valid = true;
    }

    get port()
    {
        return this.data.port;
    }

    set username(name)
    {
        if (name && name.length)
            this.data.username = name;
        this.valid = true;
    }

    get username()
    {
        return this.data.username;
    }

    set password(pass)
    {
        if (pass && pass.length)
            this.data.password = pass;
        this.valid = true;
    }

    get password()
    {
        return this.data.password;
    }

    set root(path)
    {
        if (path && path.length)
            this.data.root = path;
        this.valid = true;
    }

    get root()
    {
        return Config.userHome() + this.data.root;
    }
}

const STEPS = new Map([
    ['host', 'Server IP address'],
    ['port', 'Server port'],
    ['username', 'Username'],
    ['password', 'Password'],
    ['root', 'Folder name: ' + Config.userHome() + '/'],
]);

Config.prototype.STEPS = STEPS;
