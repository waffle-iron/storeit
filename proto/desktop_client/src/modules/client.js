'use strict';
import Config from './config';
import * as readline from 'readline';

export class Client
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        // process.stdin.setEncoding('utf8');
        this.config = new Config();

        this.readInterface = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        // this.connection = new Connection(this.config);
        // this.filetree = new Filetree(this.config);
    }

    run()
    {
        // this.filetree.watch();
        // this.connection.open();
    }

    shutdown()
    {
        this.exit = true;
        console.log('Shutting down StoreIt client...');
        this.config.save();
        // this.connection.close();
        // this.filetree.unwatch();
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
        else
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
    ['exit', Client.prototype.shutdown]
]);

Client.prototype.CMDS = CMDS;
