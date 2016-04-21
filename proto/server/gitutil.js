var git = require('nodegit')
var fs = require('fs')

function makeUser(username) {
  try {
    fs.mkdirSync(username)
  } catch (e) {}
  git.Repository.init(username + '/', 1)
}

module.exports = {
  makeUser: makeUser
}
