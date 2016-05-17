var WebSocket = require("ws")
const userfile = require('./user-file.js')

var reco_time = 1
var server_coo = 'ws://localhost:7641'
var ws = undefined

function co() {
  ws = new WebSocket(server_coo)

ws.on('error', function(error) {
    console.log("server is not reachable. attempting to reconnect in " + reco_time + " seconds")
    setTimeout(co, reco_time++ * 1000)
});

ws.on('open', function open() {
  const tree = JSON.stringify(userfile.makeUserTree())
  send_cmd('JOIN', 'fb adrien.morel@me.com ' + tree)
})

ws.on('message', function(data, falgs) {
  console.log("received " + data)
})
}

function send_cmd(name, params) {
  ws.send(name + " " + params)
}

function send_cmd_arr(name, params) {
  send_cmd(name, params.join(' '))
}


co();
exports.send_cmd = send_cmd
