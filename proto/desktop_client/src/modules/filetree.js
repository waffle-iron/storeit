'use strict';
import * as watch from 'watch';

export default class Filetree
{
    // jscs:disable disallowAnonymousFunctions

    constructor(config, callbacks)
    {
        this.config = config;
        this.callbacks = callbacks;
        this.monitor = null;
    }

    watch()
    {
        let watcher = (monitor) =>
        {
            console.log('watching test:', this.config);
            this.monitor = monitor;
            for (let [ev, func] of this.callbacks)
            {
                this.monitor.on(ev, func);
            }
        };
        watch.createMonitor(this.config.root, watcher);
    }

    unwatch()
    {
        if (this.monitor)
        {
            this.monitor.stop();
        }
    }
}
