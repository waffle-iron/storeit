import {logger} from './log.js'
import * as S from 'string'
import * as git from './git.js'

const join = function(command, arg) {

  logger.info('join with parameters ' + arg)
}

const add = (command, arg) => {

  git.add(arg.filePath)

}

export const parse = function(msg) {

  const command = JSON.parse(msg)

  const hmap = {
    'JOIN': join,
    'ADD': add
  }

  // TODO: catch the goddam exception
  logger.info(command)
  hmap[command.command](command, command.parameters)
}
