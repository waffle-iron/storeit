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

export const connectUser = (email, handlerFn) => {

  const user = new User(email)
  users[email] = user

  user.loadHome((err) => {
    handlerFn(err, user)
  })
}
