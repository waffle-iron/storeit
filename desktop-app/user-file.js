var fs = require('fs')
  path = require('path')

function mkdirUser() {
  fs.mkdir(exports.store_dir, function(err) {
    if (err) {
      console.log("cannot mkdir user dir")
    }
  })
}

function makeUserTree() {
  mkdirUser()
  dir = dirToJson(exports.store_dir)
  dir.path = "/"
  return dir
}

function makeInfo(path, kind) {
    return {
      path: path,
      metadata: "uninplemented for now",
      content_hash: "hache",
      kind: kind,
      files: []
    }
}


function dirToJson(filename) {

  var stats = fs.lstatSync(filename)

  var info = makeInfo(filename, stats.isDirectory ? 0 : 1)

  if (stats.isDirectory()) {
    info.files = fs.readdirSync(filename).map(function(child) {
      return dirToJson(filename + '/' + child)
    });
  }

  return info
}

exports.makeUserTree = makeUserTree
