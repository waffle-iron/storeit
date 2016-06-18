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

export const disconnectSocket = (socket) => {

  const user = sockets[socket]

  delete user.sockets[socket]

  if (Object.keys(user.sockets).length === 0) {
    delete users[user.email]
  }

  delete sockets[socket]
  logger.info(`${user.email} has disconnected. ${getStat()}`)
}

export const connectUser = (email, socket, handlerFn) => {

  let user = users[email]

  if (user === undefined) {
    user = new User(email)
  }

  sockets[socket] = user
  users[email] = user
  user.sockets[socket] = undefined

  user.loadHome((err) => {
    handlerFn(err, user)
  })

  logger.info(`${user.email} has connected. ${getStat()}`)
}
