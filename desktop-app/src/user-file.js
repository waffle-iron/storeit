import * as fs from 'fs'
import * as log from '../../common/log.js'

export let storeDir = './storeit'

let makeInfo = (path, kind) => {
  return {
    path,
    metadata: 'uninplemented for now',
    contentHash: 'hache',
    kind,
    files: []
  }
}

let dirToJson = (filename) => {

  let stats = fs.lstatSync(filename)

  let info = makeInfo(filename, stats.isDirectory ? 0 : 1)

  if (stats.isDirectory()) {
    info.files = fs.readdirSync(filename).map((child) => {
      return dirToJson(filename + '/' + child)
    })
  }

  return info
}

let mkdirUser = () => {
  fs.mkdir(storeDir, (err) => {
    if (err) {
      log.warn('cannot mkdir user dir')
    }
  })
}

export let makeUserTree = () => {
  mkdirUser()
  let dir = dirToJson(storeDir)
  dir.path = '/'
  return dir
}
