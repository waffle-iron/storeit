'use strict';
import FileWatcher from './file-watcher';

export default class FileTree
{
    // jscs:disable disallowAnonymousFunctions

    constructor(config, watchCallbacks)
    {
        this.config = config;
        this.watcher = new FileWatcher(config.root, watchCallbacks);
    }

    watch()
    {
        this.watcher.start();
    }

    unwatch()
    {
        this.watcher.stop();
    }
}
