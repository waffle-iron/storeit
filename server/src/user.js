import * as fs from 'fs'
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
  user.sockets[client.uid] = undefined

  user.loadHome((err) => {
    handlerFn(err, user)
  })

  logger.info(`${user.email} has connected. ${getStat()}`)
}
