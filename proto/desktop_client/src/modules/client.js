'use strict';
import Config from './config';
import Filetree from './filetree';
import * as readline from 'readline';

export class Client
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        // process.stdin.setEncoding('utf8');
        this.config = new Config();
        this.filetree = new Filetree(this.config, new Map([
            ['created', Client.prototype.fileCreated.bind(this)],
            ['changed', Client.prototype.fileChanged.bind(this)],
            ['removed', Client.prototype.fileRemoved.bind(this)],
        ]));
        // this.session = new Session(this.config);
        // this.listener = new RequestListener(this.config);


        this.readInterface = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    run()
    {
        this.filetree.watch();
        // this.session.start();
        // this.listener.open();
    }

    shutdown()
    {
        this.exit = true;
        console.log('Shutting down StoreIt client...');
        this.config.save();
        this.filetree.unwatch();
        // this.session.destroy();
        // this.listener.close();
        this.readInterface.close();
    }

    readUserInput(promptedText='storeIt> ', cb=this.matchCommand.bind(this))
    {
        this.readInterface.question(promptedText, cb);
    }

    matchCommand(input)
    {
        let cb = this.CMDS.get(input);
        if (cb != null)
        {
            cb.call(this);
        }
        else if (input.trim().length)
        {
            console.error(`${input}: invalid command`);
        }
        if (!this.exit)
        {
            this.readUserInput();
        }
    }

    fileCreated(filename, stat)
    {
        console.log(filename, 'created', stat);
    }

    fileChanged(filename, currStat, oldStat)
    {
        console.log(filename, 'changed', currStat, oldStat);
    }

    fileRemoved(filename, stat)
    {
        console.log(filename, 'removed', stat);
    }

    postpone(task, ...args)
    {
        this.readInterface.pause();
        task.call(...args);
        this.readInterface.resume();
    }

    configInit()
    {
        this.postpone(Config.prototype.init, this.config);
    }

    configReset()
    {
        this.postpone(Config.prototype.reset, this.config);
    }
}

const CMDS = new Map([
    ['config', Client.prototype.configInit],
    ['exit', Client.prototype.shutdown],
    ['reset', Client.prototype.configReset],
]);

Client.prototype.CMDS = CMDS;
