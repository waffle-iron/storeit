var WebSocketServer = require('ws').Server
var wss = WebSocketServer({ port: 7641 })
var log = require('../../common/log.js')
var proto = require('./parse.js')

var ClientStatus = {
  LOGGED: 1,
  UNLOGGED: 2
}

function Client(ws) {
  this.ws = ws

  ws.on('message', function(mess) {
    proto.parse(mess)
  })
}

var clients = []

wss.on('connection', function connection(ws) {
  clients.push(new Client(ws))
  log.info(clients)
});
