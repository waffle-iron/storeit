'use strict';
import * as crypto from 'crypto';
import * as fs from 'fs';
import * as path from 'path';

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

// Abstract class, should not be instanciated
class AFileModel
{
    // jscs:disable disallowAnonymousFunctions

    constructor(filePath, parentDir, cb)
    {
        // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
        this.path = filePath;
        this.type = null;
        this.file_medata = {};

        this.file_content_hash = crypto.createHash(HASH_FMT.type);
        this.chunks_hashes = [];
        this.hashCalculate(parentDir, cb); // pure virtual
    }

    hashUpdate(data)
    {
        // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
        this.file_content_hash.update(data);
    }

    hashDigest()
    {
        this.file_content_hash = this.file_content_hash.digest(HASH_FMT.enc);
    }

    // pure virtual hashCalculate(parentDir);
}

export class FileModel extends AFileModel
{
    // jscs:disable disallowAnonymousFunctions

    constructor(filePath, parentDir, cb)
    {
        super(filePath, parentDir, cb);
        this.type = FILE_TYPES.regular;
    }

    hashCalculate(parentDir, cb)
    {
        // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
        let fd = fs.createReadStream(this.path);

        fd.on('end', () => {
            this.hashDigest();
            if (parentDir) parentDir.hashUpdate(this.file_content_hash);
            cb(this);
        });

        fd.on('readable', () => {
            let chunk = null;
            while ((chunk = fd.read(CHUNK_SIZE)) !== null)
            {
                this.chunks_hashes.push(crypto.createHash(HASH_FMT.type)
                    .update(chunk).digest(HASH_FMT.enc));
                // console.log('chunk hash:', this.chunks_hashes.slice(-1)[0]);
                this.hashUpdate(chunk);
            }
        });
    }
}

export class DirModel extends AFileModel
{
    // jscs:disable disallowAnonymousFunctions

    constructor(filePath, parentDir, cb)
    {
        super(filePath, parentDir, cb);
        this.type = FILE_TYPES.directory;
    }

    hashCalculate(parentDir)
    {

    }
}
