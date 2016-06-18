import * as ws from 'ws'
import {logger} from './log.js'
import * as proto from './parse.js'

const PORT = 7641

const wss = ws.Server({port: PORT})

const ClientStatus = {
  LOGGED: 1,
  UNLOGGED: 2
}

class Client {

  constructor(ws) {
    this.ws = ws

    ws.on('message', (mess) => {
      proto.parse(mess)
    })
  }
}

let clients = []

wss.on('connection', (ws) => {
  clients.push(new Client(ws))
  logger.info(clients)
})

logger.info(`listening on ${PORT}`)
