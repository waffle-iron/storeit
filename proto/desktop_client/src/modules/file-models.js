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

    constructor(filePath, parentDir=null)
    {
        this.data = {
            // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
            path: filePath, // TODO change to relative
            type: null,
            file_medata: {

            },
            file_content_hash: null,
            chunks_hashes: []
        };
        this.parentDir = parentDir;
    }


    hashDigest(hash)
    {
        // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
        this.data.file_content_hash = hash.digest(HASH_FMT.enc);
    }

    printLast()
    {
        console.log('chunk hash:', this.data.chunks_hashes.slice(-1)[0]);
    }

    parentHashUpdate()
    {
        // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
        if (this.parentDir) this.parentDir.hashUpdate(this.file_content_hash);
    }
}

export class FileModel extends AFileModel
{
    // jscs:disable disallowAnonymousFunctions

    constructor(filePath)
    {
        super(filePath);
        this.data.type = FILE_TYPES.regular;
    }

    hashCalculate(fullPath)
    {
        return new Promise((resolve) =>
        {
            // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
            let fd = fs.createReadStream(fullPath);
            let hash = crypto.createHash(HASH_FMT.type);

            fd.on('end', () => {
                this.hashDigest(hash);
                this.parentHashUpdate();
                console.log('file parsed:', fullPath);
                resolve(this);
            });

            fd.on('readable', () => {
                let chunk = null;
                while ((chunk = fd.read(CHUNK_SIZE)) !== null)
                {
                    let chunkHash = crypto.createHash(HASH_FMT.type)
                        .update(chunk).digest(HASH_FMT.enc);
                    this.data.chunks_hashes.push(chunkHash);
                    hash.update(chunk);
                    // this.printLast();
                }
            });
        });
    }
}

export class DirModel extends AFileModel
{
    // jscs:disable disallowAnonymousFunctions

    constructor(filePath)
    {
        super(filePath);
        this.data.type = FILE_TYPES.directory;
        this.hash = crypto.createHash(HASH_FMT.type);
    }

    hashCalculate(dirPath)
    {
        return new Promise((resolve) =>
        {
            let files = fs.readdirSync(dirPath);
            const nbFiles = files.length;
            let count = 0;

            for (let filename of files)
            {
                let fullPath = path.join(dirPath, filename);
                this.entryParse(fullPath)
                .then(() =>
                {
                    if (++count === nbFiles)
                    {
                        this.parentHashUpdate();
                        resolve();
                    }
                })
                .catch((err) => { console.log(err); } );
            }
        });
    }

    entryParse(fullPath)
    {
        console.log('entry:', fullPath);
        let stats = fs.lstatSync(fullPath);
        let entry = null;
        if (stats.isDirectory())
            entry = new DirModel(fullPath, this);
        else
            entry = new FileModel(fullPath, this);
        return entry.hashCalculate(fullPath);
    }

    hashUpdate(data)
    {
        this.hash.update(data);
    }
}
