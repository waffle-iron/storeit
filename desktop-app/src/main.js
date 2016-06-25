import commander from 'commander'
import dotenv from 'dotenv'
dotenv.config()

import * as userfile from './user-file.js'
import * as ws from './ws.js'
import auth from './auth.js'

commander
  .version('0.0.1')
  .option('-d, --store <name>', 'set the user synced directory (default is ./storeit')
  .parse(process.argv)

if (commander.store) {
  userfile.storeDir = commander.store
}
else {
  userfile.storeDir = './storeit'
}

auth('google')
  .then((tokens) => {
    //   ws.co(tokens.access_token)
  })
