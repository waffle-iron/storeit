import * as fs from 'fs'
import * as path from 'path'
import {logger} from './log.js'
let usersDir = "./storeit-users/"

const readHome = (email, handlerFn) => {
  fs.readFile(usersDir + email, 'utf8', (err, data) => {
    if (err) {
      return handlerFn(err)
    }

    handlerFn(err, JSON.parse(data))
  })
}

export class User {

  constructor(email) {
    this.email = email
    this.sockets = {}
    this.commandUid = 0
  }

  setTree(trees, action) {
    if (this.home === undefined) {
      logger.error('home has not loaded')
    }

    for (const treeIncoming in trees) {

      const pathToFile = treeIncoming.path.split(path.sep)
      const stepInto = (path, tree) => {

        if (pathToFile.length === 1) {
          return action(tree, treeIncoming, pathToFile[0])
        }

        const name = pathToFile.shift()
        return stepInto(pathToFile, tree[name])
      }
    }
  }

  addTree(trees) {
    return this.setTree(trees, (treeParent, tree, name) => {
      treeParent.files[name] = tree
    })
  }

  uptTree(trees) {
    return this.setTree(trees, (treeParent, tree, name) => {
      treeParent.files[name] = tree
    })
  }

  delTree(trees) {
    return this.setTree(trees, (tree, name) => delete tree[name])
  }

  loadHome(handlerFn) {
    readHome(this.email, (err, obj) => {
      this.home = obj
      handlerFn(err, obj)
    })
  }
}

export const setUsersDir = (name) => {
  usersDir = name
}

export const users = {}
export const sockets = {}

const getStat = () => {
  return `${Object.keys(users).length} users ${Object.keys(sockets).length} sockets.`
}

export const disconnectSocket = (client) => {

  const user = sockets[client.uid]

  delete user.sockets[client.uid]

  if (Object.keys(user.sockets).length === 0) {
    delete users[user.email]
  }

  delete sockets[client.uid]
  logger.info(`${user.email} has disconnected. ${getStat()}`)
}

export const connectUser = (email, client, handlerFn) => {

  let user = users[email]

  if (user === undefined) {
    user = new User(email)
  }

  sockets[client.uid] = user
  users[email] = user
  user.sockets[client.uid] = client

  user.loadHome((err) => {
    handlerFn(err, user)
  })

  logger.info(`${user.email} has connected. ${getStat()}`)
}
