import * as fs from 'fs'

import open from 'open'
// import * as jsonf from 'json-file'
import express from 'express'
import gapi from 'googleapis'

import * as log from '../../common/log.js'

const REDIRECT_URI = 'http://localhost:7777'
const TOKENS_FILE = './.tokens.json'

class AuthProvider {
  constructor() {
    this.server = express()
    this.loadTokens()
  }

  listenRedirect() {
    return new Promise((resolve, reject) => {
      this.server.use('/', (req, res) => {
        let msg = 'Thank you for authenticating, you can now quit this page.'
        res.send(`StoreIt: ${msg}`)

        let code = req.query.code
        code != null ? resolve(code) : reject({err: 'could not get code'})
      })
      this.server.listen(7777)
      console.log('Listening port 7777, waiting for auth redirect...')
    })
  }

  loadTokens() {
    let file = fs.readFileSync(TOKENS_FILE)
    this.tokens = JSON.parse(file)
  }

  saveTokens(tokens) {
    Object.assign(this.tokens, tokens)
    fs.writeFileSync(TOKENS_FILE, JSON.stringify(this.tokens))
  }
}

class GoogleService extends AuthProvider {
  constructor() {
    super()

    this.client = new gapi.auth.OAuth2(process.env.GAPI_CLIENT_ID,
      process.env.GAPI_CLIENT_SECRET, REDIRECT_URI)
  }
  oauth() {
    let url = this.client.generateAuthUrl({scope: 'email'})
    let tokenPromise = this.listenRedirect()
      .then((code) => this.getToken(code))

    open(url)
    return tokenPromise
  }

  getToken(code) {
    return new Promise((resolve, reject) => {
      this.client.getToken(code, (err, tokens) => {
        if(!err) {
          this.client.setCredentials(tokens)
          this.saveTokens({google: tokens})
          resolve(tokens)
        }
        else {
          log.error(err)
          reject(err)
        }
      })
    })
  }
}

class FacebookService extends AuthProvider {
  constructor() {
    super()
  }

  oauth() {
    throw {msg: 'facebook oauth not supported yet'}
  }

  getToken() {
    throw {msg: 'facebook oauth not supported yet'}
  }
}

let oauth = (type) => {
  let auth = null
  switch (type) {
  case 'facebook':
    auth = new FacebookService()
    auth.oauth()
    break
  case 'google':
    auth = new GoogleService()
    auth.oauth()
    break
  default:
    throw {msg: 'StoreIt auth not implemented yet'}
  }
}

export default oauth
