import * as log from '../../common/log.js'
import * as S from 'string'

const join = function(arg) {

  const args = S(arg).splitLeft(' ', 2)
  log.info('join with parameters ' + args[1])
}

export const parse = function(msg) {
  const msgArr = S(msg).splitLeft(' ', 1)

  const hmap = {
    'JOIN': join
  }

  const cmd = msgArr.shift()
  // TODO: catch the goddam exception
  hmap[cmd](msgArr[0])
}
