import * as ws from 'ws'
import * as log from '../../common/log.js'
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
  log.info(clients)
})

log.info(`listening on ${PORT}`)
