var commander = require('commander')
var userfile = require('./user-file.js')
var ws = require('./ws.js')

commander
  .version('0.0.1')
  .option('-d, --store <name>', 'set the user synced directory (default is ./storeit')
  .parse(process.argv)

if (commander.store) {
  userfile.store_dir = commander.store
} else {
  userfile.store_dir = "./storeit"
}
//ws.send_cmd('JOIN foobar')
