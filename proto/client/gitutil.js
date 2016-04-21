var git = require('nodegit')
var path = require('path')
var helper = require('./helper.js')
var exec = require('child_process').exec;

var repo
var repo_path = path.resolve(__dirname, "./storeit_git/")
var user_path = path.resolve(__dirname, "./storeit/")
var repo_addr = "ssh://git@iglu.mobi/git/storeit-test"

function gitcmd() {
  return "git -C " + repo_path + " "
}

function setRepo(path) {
  repo_path = path
}

function getRepo() {
  return repo_path + "/"
}

function setUserPath(path) {
  user_path = path
}

function getUserPath() {
  return user_path + "/"
}

function logerr(error, msg, stdout) {
  if (!error)
    return;
  console.log(msg + ":" + error + "\n" + stdout)
}

function clone(done) {
  exec("git clone " + repo_addr + " " + repo_path, function(error, stdout, stderr) {
    logerr(error, "clone")
    done()
  })
}

function change(file, action, done) {
  exec(gitcmd() + " " + action + " '" + getRepo() + "/" + file + "'", function(error, stdout, stderr) {
    logerr(error, "add")
    done()
  })
}
function commit(file, action) {

if (action == undefined) {
  action = "add"
}

  change(file, action, function() {
    exec(gitcmd() + "commit -am 'automatic commit from Desktop'", function(error, stdout, stderr) {
      logerr(error, "commit", stdout)
      push()
    })
  })
}

function push() {
  pull()
  exec(gitcmd() + "push", function(error, stdout, stderr) {
    logerr(error, "push")
  })
}

function prepareRepo(done) {
  clone(function() {
    done()
  })
}

function pull() {
  exec(gitcmd() + "pull --rebase")
}

/*

function clone() {
return git.Clone.clone('./gitrepos/tom/', repo_path, {local: 1})
}

function add(files) {

const ds = repo.defaultSignature()

console.log("adding " + files)
repo.createCommitOnHead(files, ds, ds, 'desktop').then(function(oid) {
return repo.getRemote("origin")
}).then(function(remoteResult) {

remote = remoteResult;

// Create the push object for this remote
return remote.push(["refs/heads/master:refs/heads/master"])
}).done(function() {
console.log("pushed !")
})
}

function prepareRepo() {

console.log("prepare repo with " + repo_path)
return git.Repository.open(repo_path).then(function(repository) {
return repository
}).catch(function(err) {
return clone()
}).then(function(repository) {
repo = repository
}).catch(function(err) {
console.error("1:" +err)
})
}

function pull() {

repo.fetchAll().then(function() {
return repo.mergeBranches("master", "origin/master")
}).catch(function(err) {
console.log(err.hasConflicts())
helper.errWithStack(err)
}).catch(function(err) {
console.log(err)
})
}
*/

module.exports = {
  clone: clone,
  prepareRepo: prepareRepo,
  pull: pull,
  setRepo: setRepo,
  getRepo: getRepo,
  setUserPath: setUserPath,
  getUserPath: getUserPath,
  commit: commit,

  repo_path: repo_path
}
