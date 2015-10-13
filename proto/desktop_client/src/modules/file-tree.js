'use strict';
import * as crypto from 'crypto';
import * as fs from 'fs';

import FileWatcher from './file-watcher';

const CHUNK_SIZE = 10 * 1024 * 1024; // 10MB
const FILE_TYPES = {
    directory: 0,
    regular: 1,
    link: 2
};
const HASH_FMT = {
    type: 'sha256',
    enc: 'hex'
};

class FileModel
{
    // jscs:disable disallowAnonymousFunctions

    constructor(path)
    {
        // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
        this.path = path;
        this.type = FILE_TYPES.regular;
        this.file_medata = {};

        this.file_content_hash = null;
        this.chunks_hashes = [];
        this.fileHashesCalc();
    }

    fileHashesCalc()
    {
        // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
        let fd = fs.createReadStream(this.path);
        let fileHash = crypto.createHash(HASH_FMT.type);

        fd.on('end', () => {
            this.file_content_hash = fileHash.digest(HASH_FMT.enc);
            // console.log('=====>file hash:', this.file_content_hash);
        });

        fd.on('readable', () => {
            let chunk = null;
            while ((chunk = fd.read(CHUNK_SIZE)) !== null)
            {
                this.chunks_hashes.push(crypto.createHash(HASH_FMT.type)
                    .update(chunk).digest(HASH_FMT.enc));
                // console.log('chunk hash:', this.chunks_hashes.slice(-1)[0]);
                fileHash.update(chunk);
            }
        });
    }
}

export default class FileTree
{
    // jscs:disable disallowAnonymousFunctions

    constructor(watchCallbacks)
    {
        this.init();
        this.list = [];
        this.watcher = new FileWatcher(watchCallbacks);
    }

    init()
    {
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
