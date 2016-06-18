import WebSocket from 'ws'
import * as userfile from './user-file.js'
import {logger} from './log.js'
import {Command} from './protocol-objects'

let recoTime = 1
let serverCoo = 'ws://localhost:7641'
let ws = undefined

export let sendCmd = (cmd) => {
  const cmdString = JSON.stringify(cmd)
  logger.info('sending ' + cmdString)
  ws.send(cmdString)
}

export let co = (accessToken) => {
  ws = new WebSocket(serverCoo)

  ws.on('error', () => {
    logger.error('server is not reachable. attempting to reconnect in ' + recoTime + ' seconds')
    setTimeout(co, recoTime++ * 1000)
  })

  ws.on('open', function open() {
    const tree = userfile.makeUserTree()

    sendCmd(new Command('JOIN', [
      {authType: 'fb'},
      {accessToken: 'blahblah'},
      {home: tree}
    ]))
  })

  ws.on('message', (data) => {
    logger.debug('received ' + data)
  })
}
