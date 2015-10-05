'use strict';
// import * as fs from 'fs';

export default class chunkManager
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        this.chunks = [];
    }

    addchunk(chunk)
    {
        this.chunks.push(chunk);
    }

    deletechunk(chunk)
    {
        return chunk;
    }

    getchunk(hash)
    {
        return chunk;
    }
}
