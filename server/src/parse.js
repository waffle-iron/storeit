import * as log from './log.js'
import * as S from 'string'

const join = function(arg) {

  const args = S(arg).splitLeft(' ', 2)
  log.info('join with parameters ' + args[1])
}

const add = (arg) => {
}

export const parse = function(msg) {
  const msgArr = S(msg).splitLeft(' ', 1)

  const hmap = {
    'JOIN': join,
    'ADD': add
  }

  const cmd = msgArr.shift()
  // TODO: catch the goddam exception
  hmap[cmd](msgArr[0])
}
