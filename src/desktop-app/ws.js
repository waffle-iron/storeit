var WebSocket = require("ws")
const userfile = require('./user-file.js')
var ws = new WebSocket('ws://localhost:7641')

ws.on('open', function open() {
  const tree = JSON.stringify(userfile.makeUserTree())
  send_cmd('JOIN', 'fb adrien.morel@me.com ' + tree)
})

ws.on('message', function(data, falgs) {
  console.log("received " + data)
})

function send_cmd(name, params) {
  ws.send(name + " " + params)
}

function send_cmd_arr(name, params) {
  send_cmd(name, params.join(' '))
}

exports.send_cmd = send_cmd
