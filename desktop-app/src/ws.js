import WebSocket from 'ws'
import * as userfile from './user-file.js'
import * as log from '../../common/log.js'

let recoTime = 1
let serverCoo = 'ws://localhost:7641'
let ws = undefined

export let sendCmd = (name, params) => {
  const cmd = name + ' ' + params
  log.info('sending command ' + cmd)
  ws.send(cmd)
}

export let co = (accessToken) => {
  ws = new WebSocket(serverCoo)

  ws.on('error', () => {
    log.error('server is not reachable. attempting to reconnect in ' + recoTime + ' seconds')
    setTimeout(co, recoTime++ * 1000)
  })

  ws.on('open', function open() {
    const tree = JSON.stringify(userfile.makeUserTree())
    sendCmd('JOIN', 'fb adrien.morel@me.com ' + accessToken + ' ' + tree)
  })

  ws.on('message', (data) => {
    console.log('received ' + data)
  })
}

let sendCmdArr = (name, params) => {
  sendCmd(name, params.join(' '))
}