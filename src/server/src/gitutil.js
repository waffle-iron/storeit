import git from 'nodegit'
import fs from 'fs'

let makeUser = function(username) {
  try {
    fs.mkdirSync(username)
  }
  catch (e) {}
  git.Repository.init(username + '/', 1)
}

export default {
  makeUser
}
