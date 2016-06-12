import * as gitutil from './git.js'
import * as log from './log.js'

gitutil.setUsersDir('/tmp/storeit-users/')

gitutil.addUser('sevauk', (err) => {
  if (err) {
    log.error(err)
  }
})
