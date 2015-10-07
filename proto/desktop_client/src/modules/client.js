'use strict';
import * as readline from 'readline';
import Config from './config';
import Filetree from './filetree';
import HttpSession from './httpSession';

export class Client
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        // process.stdin.setEncoding('utf8');
        this.config = new Config();
        this.session = new HttpSession(this.config);
        this.filetree = new Filetree(this.config, new Map([
            ['created', HttpSession.prototype.fileCreated.bind(this.session)],
            ['changed', HttpSession.prototype.fileChanged.bind(this.session)],
            ['removed', HttpSession.prototype.fileRemoved.bind(this.session)]
        ]));
        // this.listener = new HttptListener(this.config);

        this.readInterface = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    run()
    {
        this.filetree.watch();
        // this.listener.start();
        this.session.join(this.filetree.list);
    }

    shutdown()
    {
        this.exit = true;
        console.log('Shutting down StoreIt client...');
        this.config.save();
        this.filetree.unwatch();
        this.session.leave();
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

    postpone(task, ...args)
    {
        this.readInterface.pause();
        task.call(...args);
        this.readInterface.resume();
    }

    configInit()
    {
        this.postpone(Config.prototype.init, this.config, true);
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
    ['run', Client.prototype.run],
]);

Client.prototype.CMDS = CMDS;
