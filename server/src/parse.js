import {logger} from './log.js'
import * as S from 'string'
import * as git from './git.js'
import * as user from './user.js'
import * as protoObjs from './protocol-objects'

const join = function(command, arg, socket) {

  // TODO: error checking on JSON

  user.connectUser('adrien.morel@me.com', socket, (err, user) => {
    if (err) {
      return logger.error('could not connect user')
    }

    socket.sendObj(new protoObjs.Response(0, "welcome", command.uid, {
      home: user.home
    }))
  })
}

const recast = (command, client) => {

  const usr = client.getUser()
  command.uid = ++usr.commandUid
  for (const sock in usr.sockets) {
    if (sock == client.uid) {
      continue
    }
    usr.sockets[sock].sendObj(command)
  }
}

const add = (command, arg, client) => {
  const uid = command.uid
  recast(command, client)
  client.answerSuccess(uid)
}

export const parse = function(msg, client) {

  const command = JSON.parse(msg)

  const hmap = {
    'JOIN': join,
    'FADD': add
  }

  // TODO: catch the goddam exception
  hmap[command.command](command, command.parameters, client)
}
