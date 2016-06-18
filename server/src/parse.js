import {logger} from './log.js'
import * as S from 'string'
import * as git from './git.js'
import * as user from './user.js'
import * as protoObjs from './protocol-objects'

const join = function(command, arg, client) {

  // TODO: error checking on JSON

  user.connectUser('adrien.morel@me.com', (err, user) => {
    if (err) {
      return logger.error('could not connect user')
    }

    client.sendObj(new protoObjs.Reponse(0, "welcome", command.uid, {
      home: user.home
    }))
  })
}

const add = (command, arg) => {

  git.add(arg.filePath)

}

export const parse = function(msg, client) {

  const command = JSON.parse(msg)

  const hmap = {
    'JOIN': join,
    'ADD': add
  }

  // TODO: catch the goddam exception
  logger.info(command)
  hmap[command.command](command, command.parameters, client)
}
