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
    logger.error('server socket error')
  })

  ws.on('open', function open() {

    sendCmd(new Command('JOIN', {
      authType: 'fb',
      accessToken: 'blahblah',
    }))

    sendCmd(new Command('FADD', {
      'files': [{'name': 'Iam a happy file object'}]
    }))
  })

  ws.on('message', (data) => {
    logger.info('received ' + data)
  })

  ws.on('close', (a, b) => {
    logger.error('attempting to reconnect in ' + recoTime + ' seconds')
    setTimeout(co, recoTime * 1000)

    const MAX = 4
    if (recoTime < MAX) {
      recoTime++
    }
  })
}
