import commander from 'commander'
import dotenv from 'dotenv'
dotenv.config()

import * as userfile from './user-file'
import * as win from './win'

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

win.openLoginWin()
