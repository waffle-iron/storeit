var gitutil = require('./gitutil.js')
var fs = require('fs')
var watcher = require('./watcher.js')
var commander = require('commander')
var path = require('path')

commander
  .version('0.0.1')
  .option('-d, --store <name>', 'set the user synced directory')
  .parse(process.argv)

if (commander.store) {
  gitutil.setRepo(path.resolve(__dirname, commander.store + "_git"))
  gitutil.setUserPath(path.resolve(__dirname, commander.store))
}

watcher.poll()

  /*
var access = fs.createWriteStream(gitutil.getRepo() + '.log', { flags: 'a' })
      , error = fs.createWriteStream(gitutil.getRepo() + '.log', { flags: 'a' });

// redirect stdout / stderr
process.stdout.pipe(access);
process.stderr.pipe(error);
*/
