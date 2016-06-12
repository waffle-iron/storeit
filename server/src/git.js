import fs from 'fs'
import * as log from './log.js'
export let usersDir = '../users/'

// could figure out how to ES6 import this
const git = require('simple-git')()

git.addConfig('user.name', 'StoreIt server')
.addConfig('user.email', 'admin@storeit.io')

export const setUsersDir = (name) => {
  usersDir = name
}

export const addUser = (name, handlerFn) => {

  const repositoryPath = `${usersDir}${name}`

  try {
    fs.mkdir(repositoryPath, (err) => {
      log.ifnerr(err, 'cannot create user', 'mkdir success', () => {
        process.chdir(repositoryPath)
        git.init((err) => {
          log.ifnerr(err, 'cannot create user', 'successfully created user directory')
        })
      })
    })
  }
  catch (err) {
    console.log(err)
  }
}
