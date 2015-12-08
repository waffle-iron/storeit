'use strict';
import express from 'express';

export default class HttpListener
{
    // jscs:disable disallowAnonymousFunctions

    constructor()
    {
        this.router = express();
        this.routesDefine();
        this.listening = false;
    }

    start()
    {
        this.server = this.router.listen(7642, () => {
            this.listening = true;
            this.host = this.server.address().address;
            this.port = this.server.address().port;

            console.log('storeit client listening at http://%s/%s',
                this.host, this.port);
        });
    }

    stop()
    {
        if (this.listening)
        {
            this.server.close();
            console.log('storeit client closed connection');
        }
    }

    routesDefine()
    {
        this.router.get('/session/ping', this.getPing.bind(this));
    }

    getPing(req, res)
    {
        res.end();
    }
}
