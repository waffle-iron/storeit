import commander from 'commander'
import dotenv from 'dotenv'
dotenv.config()

import * as userfile from './user-file'
import * as loginGui from './login-gui'
import * as settingsGui from './settings-gui'

commander
    .version('0.0.1')
    .option('-s, --settings', 'Open a configuration  window')
    .option('-d, --store <name>', 'Set the user synced directory (default is ./storeit)')
  .parse(process.argv)

if (commander.store) {
  userfile.storeDir = commander.store
}
else {
  userfile.storeDir = './storeit'
}

if (commander.settings) {
    settingsGui.openSettingsGui()
} else {
    loginGui.openLoginGui()
}