const log = require('../../common/log.js')
const S = require('string')

function parse(msg) {
  const msg_arr = S(msg).splitLeft(' ', 1)

  var hmap = {
    'JOIN': join
  }

  const cmd = msg_arr.shift()
  // TODO: catch the goddam exception
  hmap[cmd](msg_arr[0])
}

function join(arg) {

  const args = S(arg).splitLeft(' ', 2)
  log.info('join with parameters ' + args[1])
}

exports.parse = parse
