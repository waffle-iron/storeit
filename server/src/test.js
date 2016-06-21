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

const expectUsualJoinResponse = (data) => {

  const obj = JSON.parse(data)

  expect(obj.code).to.equal(0)
  expect(obj.parameters.home.path).to.equal('/')
}

describe('simple connection', () => {

  let fakeA = undefined
  let fakeB = undefined

  it('should get JOIN response', (done) => {
    fakeA = new fakeUser('adrien.morel@me.com')

    fakeA.ws.on('message', (data) => {
      expectUsualJoinResponse(data)
      done()
    })
  })

  it('should connect another client', (done) => {
    fakeB = new fakeUser('adrien.morel@me.com', done)
    fakeB.ws.on('message', (data) => {
      expectUsualJoinResponse(data)
      done()
    })
  })

  it('should have correct number of connected user', () => {
      expect(user.getUserCount()).to.equal(1)
      expect(user.getConnectionCount()).to.equal(2)
  })

  it('should disconnect user without issue', (done) => {
    fakeA.leave()
    fakeA.ws.on('close', () => {
      setTimeout(() => {
        expect(user.getConnectionCount()).to.equal(1)
        expect(user.getUserCount()).to.equal(1)
        done()
      }, 100 // wait for server to take action)
    })
  })
})
