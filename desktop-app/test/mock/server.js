import dotenv from 'dotenv'
import WebSocket from 'ws'

dotenv.config()

let wss = new WebSocket.Server({port: process.env.SERVER_PORT})

console.info(`mock-server listening on port ${process.env.SERVER_PORT}`)

wss.on('connection', function connection(ws) {
  console.log('connection')

  ws.on('message', function incoming(message) {
    console.log('received: %s', message)
  })

  ws.send('welcome')
})
