'use strict';
import * as readline from 'readline';
import Config from './config';
import FileTree from './file-tree';
import HttpSession from './http-session';

export class Client
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        // process.stdin.setEncoding('utf8');
        this.config = new Config();
        this.session = new HttpSession(this.config);
        this.fileTree = new FileTree(this.config, new Map([
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
        this.fileTree.watch();
        // this.listener.start();
        this.session.join(this.filetree.list);
    }

    shutdown()
    {
        this.exit = true;
        console.log('Shutting down StoreIt client...');
        this.config.save();
        this.fileTree.unwatch();
        this.session.leave();
        // this.listener.close();
        this.readInterface.close();
    }

    configInit()
    {
        this.postpone(Config.prototype.init, this.config, true);
    }

    configReset()
    {
        this.postpone(Config.prototype.reset, this.config);
    }

    readUserInput(promptedText='storeIt> ', cb=this.matchCommand.bind(this))
    {
        this.readInterface.question(promptedText, cb);
    }

    postpone(task, ...args)
    {
        this.readInterface.pause();
        task.call(...args);
        this.readInterface.resume();
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
}

const CMDS = new Map([
    ['config', Client.prototype.configInit],
    ['exit', Client.prototype.shutdown],
    ['reset', Client.prototype.configReset],
    ['run', Client.prototype.run],
]);

Client.prototype.CMDS = CMDS;
