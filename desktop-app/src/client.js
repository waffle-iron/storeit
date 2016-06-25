import WebSocket from 'ws'

import {FacebookService, GoogleService} from './oauth'
import * as userfile from './user-file'
import * as log from '../../common/log'

let recoTime = 1

export default class Client {

  constructor() {
    this.connect()
  }

  auth(type) {
    let service = null
    switch (type) {
    case 'facebook':
      service = new FacebookService()
      return service.oauth()
      break
    case 'google':
      service = new GoogleService()
      return service.oauth()
      break
    default:
      return this.storeitAuth()
    }
  }

  storeitAuth() {
    throw {msg: 'StoreIt auth not implemented yet'}
  }

  connect() {
    const {SERVER_HOST, SERVER_PORT} = process.env
    this.sock = new WebSocket(`ws://${SERVER_HOST}:${SERVER_PORT}`)

    this.sock.on('open', () => this.sendUserTree())
    this.sock.on('close', () => this.reconnect())
    this.sock.on('error', () => log.error('socket error occured'))
    this.sock.on('message', (data) => this.recv(data))
  }

  reconnect() {
    log.error('attempting to reconnect in ' + recoTime + ' seconds')
    setTimeout(() => this.connect(), recoTime * 1000)

    const MAX = 4
    if (recoTime < MAX) {
      recoTime++
    }
  }

  sendUserTree() {
    return this.send(userfile.makeUserTree())
  }

  send(data) {
    log.info(`sending command ${data.cmd}`)
    return new Promise((resolve, reject) =>
      this.sock.send(JSON.stringify(data), (err) =>
        !err ? resolve(data) : reject(err)
      )
    )
  }

  recv(data) {
    return new Promise((resolve) => resolve(JSON.parse(data)))
  }
}
