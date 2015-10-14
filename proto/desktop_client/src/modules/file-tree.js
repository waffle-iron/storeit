'use strict';
import * as fs from 'fs';
import * as path from 'path';

import FileWatcher from './file-watcher';
import {FileModel, DirModel} from './file-models';

export default class FileTree
{
    // jscs:disable disallowAnonymousFunctions

    constructor(watchCallbacks)
    {
        this.list = [];
        this.init();
        this.watcher = new FileWatcher(watchCallbacks);
    }

    init()
    {
        this.treeParseRec(global.config.root);
    }

    treeParseRec(dirPath)
    {
        let dir = dirPath !== global.config.root ? new DirModel(dirPath) : null;
        let files = fs.readdirSync(dirPath);
        for (let filename of files)
        {
            let fullPath = path.join(dirPath, filename);
            let stats = fs.lstatSync(fullPath);
            if (!stats.isDirectory())
            {
                this.fileAnalyze(fullPath, dir);
            }
            // else
            // {
            //     this.treeParseRec(fullPath);
            // }
        }
    }

    fileAnalyze(fullPath, parentDir)
    {
        let file = new FileModel(fullPath, parentDir, (file) => {
            // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
            console.log('=====>file hash:', file.file_content_hash);
        });
        // console.log(file);
    }

    watch()
    {
        this.watcher.start();
    }

    unwatch()
    {
        this.watcher.stop();
    }

    static fileExists(path)
    {
        try
        {
            fs.accessSync(path, fs.R_OK | fs.W_OK);
        }
        catch (e)
        {
            return false;
        }
        return true;
    }
}
