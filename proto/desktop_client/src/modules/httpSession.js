'use strict';
import * as https from 'https';
import * as queryString from 'querystring';
import Filetree from './filetree';

class HttpSessionRequest
{
    // jscs:disable disallowAnonymousFunctions

    constructor(method, path)
    {
        this.options = {
            hostname: this.config.host,
            port: this.config.port,
            auth: `${this.config.username}:${this.config.password}`,
            method: method,
            path: path
        };
        this.data = null;
    }

    dataSet(data)
    {
        if (this.hasBody())
        {
            let reqData = JSON.stringify(data);
            this.options.headers = {
                'Content-Type': 'application/json',
                'Content-Length': reqData.length
            };
            this.data = data;
        }
        else
        {
            let reqParams = queryString.stringify(data);
            this.path += '?' + reqParams;
        }
    }

    send(cb)
    {
        let req = https.request(this, cb);
        req.write(this.data);
        req.end();
    }

    hasBody()
    {
        return this.options.method !== 'DELETE';
        // && this.options.method !== 'GET';
    }
}

export default class HttpSession
{
    // jscs:disable disallowAnonymousFunctions

    constructor(config)
    {
        this.config = config;
    }

    join(filelist)
    {
        this.request('POST', '/session/join', filelist, (res) => {
            if (res.statusCode === 200)
                console.log('join success.');
            else
                console.log('join fail');
        });
    }

    leave()
    {
        this.request('POST', '/session/leave', (res) => {
            console.log('Session closed with status', res);
            // if (res.statusCode === 200)
            //     console.log('leave success.');
            // else
            //     console.log('leave fail');
        });
    }

    fileCreated(filename, stat)
    {
        this.fileUpdateSend('PUT', filename, stat);
    }

    fileChanged(filename, stat)
    {
        this.fileUpdateSend('POST', filename, stat);
    }

    fileUpdateSend(method, filename, stat)
    {
        let file = Filetree.makeFileInfo(filename, stat);
        let action = method === 'PUT' ? 'added' : 'updated';
        this.request(method, '/data/tree', file, (res) => {
            if (res.statusCode === 200)
                console.log('file', filename, 'successfully', action);
            else // if error
            {
                let msg = `file ${filename} not ${action}.`;
                if (res.statusCode === 401)
                    console.error(msg, 'Storage full.');
                else // 409
                    console.error(msg, 'File already exists.');
            }
        });
    }

    fileRemoved(filename)
    {
        let reqParams = {
            // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
            file_path: filename
        };
        this.request('DELETE', '/data/tree', reqParams, (res) => {
            console.log('file', filename, 'removed with code', res.statusCode);
        });
    }

    request(method, path, data, cb)
    {
        let req = new HttpSessionRequest(method, path);
        req.dataSet(data);
        req.send(cb);
    }
}
