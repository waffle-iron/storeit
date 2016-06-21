
logger.transports.console.level = 'error';

import * as mocha from 'mocha'
import {logger} from './log.js'
import {assert, expect} from 'chai'
import WebSocket from 'ws'
import * as api from './protocol-objects'
import './ws.js'

class fakeUser {

  send(obj) {
    this.ws.send(JSON.stringify(obj))
  }

  constructor(email, done) {
    this.ws = new WebSocket('ws://localhost:7641')
    this.ws.on('open', () => {
      this.join()
    })

    this.ws.on('message', (data) => {
      const obj = JSON.parse(data)

      if (obj.commandUid === undefined) {
      }

      else {
        expect(obj.code).to.equal(0)
        expect(obj.commandUid).to.equal(0)
        expect(obj.parameters.home.path).to.equal('/')
        done()
      }
    })
  }

  join() {
    this.send(new api.Command('JOIN', {
      authType: 'fb',
      accessToken: 'blabhla'
    }))
  }
}

describe('simple connection', () => {

  it('should get JOIN response', (done) => {

    const fake = new fakeUser('adrien.morel@me.com', done)
  })

  afterEach((done) => {
    done()
  })
})
