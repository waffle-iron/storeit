logger.transports.console.level = 'error';

import {logger} from './log.js'
import {expect} from 'chai'
import WebSocket from 'ws'
import * as api from './protocol-objects'
import './ws.js'
import * as user from './user.js'

class fakeUser {

  send(obj) {
    this.ws.send(JSON.stringify(obj))
  }

  constructor(email) {
    this.ws = new WebSocket('ws://localhost:7641')
    this.ws.on('open', () => {
      this.join()
    })
    this.msgHandler = undefined

    this.ws.on('message', (data) => {
      this.msgHandler(data)
    })
  }

  join() {
    this.send(new api.Command('JOIN', {
      authType: 'fb',
      accessToken: 'blabhla'
    }))
  }

  leave() {
    this.ws.close()
  }
}

const expectOkResponse = (data) => {
  const obj = JSON.parse(data)

  expect(obj.code).to.equal(0)
}

const expectUsualJoinResponse = (data) => {

  const obj = JSON.parse(data)

  expectOkResponse(data)
  expect(obj.parameters.home.path).to.equal('/')
}

let fakeA = undefined
let fakeB = undefined

describe('simple connection', () => {

  it('should get JOIN response', (done) => {
    fakeA = new fakeUser('adrien.morel@me.com')

    fakeA.msgHandler = (data) => {
      expectUsualJoinResponse(data)
      done()
    }
  })

  it('should connect another client', (done) => {
    fakeB = new fakeUser('adrien.morel@me.com', done)
    fakeB.msgHandler = (data) => {
      expectUsualJoinResponse(data)
      done()
    }
  })

  it('should have correct number of connected user', () => {
    expect(user.getUserCount()).to.equal(1)
    expect(user.getConnectionCount()).to.equal(2)
  })

})

describe('protocol file commands', () => {
  const makeFileObj = (path, IPFSHash, files) => {
    if (IPFSHash === undefined) {
      IPFSHash = null
    }
    if (files === undefined) {
      files = null
    }

    return {
      path: path,
      metadata: null,
      IPFSHash: IPFSHash,
      isDir: IPFSHash == null,
      files: files,
    }
  }

  it('should disconnect user without issue', (done) => {
    fakeB.ws.on('close', () => {
      setTimeout(() => {
        expect(user.getConnectionCount()).to.equal(1)
        expect(user.getUserCount()).to.equal(1)
        done()
      }, 100) // wait for server to take action
    })

    fakeB.leave()
  })

  it('should FADD correctly', (done) => {

    fakeA.msgHandler = (data) => {
      expectOkResponse(data)
      expect(
        makeFileObj('/', null, {
          'foo': makeFileObj('/foo', null, {
            'bar.txt': makeFileObj('/foo/bar.txt')
          })
        })).to.deep.equal(user.users['adrien.morel@me.com'].home),
      done()
    }

    fakeA.send(new api.Command('FADD', {
      files: [
        makeFileObj('/foo', null, {'bar.txt': makeFileObj('/foo/bar.txt')}),
      ]
    }))

  })
})
