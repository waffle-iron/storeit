'use strict';
import * as watch from 'watch';

export default class FileWatcher
{
    // jscs:disable disallowAnonymousFunctions

    constructor(root, callbacks)
    {
        this.rootDir = root;
        this.callbacks = callbacks;
        this.monitor = null;
    }

    start()
    {
        watch.createMonitor(this.rootDir, (monitor) => {
            console.log('watching test:', this.config);
            this.monitor = monitor;
            for (let [ev, func] of this.callbacks)
            {
                this.monitor.on(ev, func);
            }
        });
    }

    stop()
    {
        if (this.monitor)
        {
            this.monitor.stop();
        }
    }
}
