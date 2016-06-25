import * as fs from 'fs'

import open from 'open'
import express from 'express'
import gapi from 'googleapis'

import * as log from '../../common/log'

const REDIRECT_URI = 'http://localhost:7777'
const TOKENS_FILE = './.tokens.json'

class OAuthProvider {
  constructor() {
    this.express = express()
    this.loadTokens()
  }

  waitAuthorized() {
    return new Promise((resolve, reject) => {
      this.express.use('/', (req, res) => {
        let msg = 'Thank you for authenticating, you can now quit this page.'
        res.send(`StoreIt: ${msg}`)

        this.http.close()
        log.info('Access granted, Http server stopped')

        let code = req.query.code
        code != null ? resolve(code) : reject({err: 'could not get code'})
      })

      this.http = this.express.listen(7777)
      log.info('Http server listening on port 7777,' +
        'waiting for user authorization')
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

export class GoogleService extends OAuthProvider {
  constructor() {
    super()

    this.client = new gapi.auth.OAuth2(process.env.GAPI_CLIENT_ID,
      process.env.GAPI_CLIENT_SECRET, REDIRECT_URI)
    if (this.hasRefreshToken()) {
      /* eslint-disable camelcase */
      let {access_token, refresh_token} = this.tokens.google
      this.client.setCredentials({
        access_token,
        refresh_token
      })
      /* eslint-enable camelcase */
    }
  }

  oauth() {
    if (this.hasRefreshToken())
      return this.getToken()

    let url = this.client.generateAuthUrl({
      scope: 'email',
      access_type: 'offline' // eslint-disable-line camelcase
    })
    let tokenPromise = this.waitAuthorized()
      .then((code) => this.getToken(code))

    open(url)
    return tokenPromise
  }

  getToken(code) {
    return new Promise((resolve, reject) => {
      let manageTokens = (err, tokens) => {
        if(!err) {
          this.client.setCredentials(tokens)
          this.saveTokens({google: tokens})
          resolve(tokens)
        }
        else {
          log.error(err)
          reject(err)
        }
      }

      if (code != null) {
        log.info('exchanging code against access token')
        return this.client.getToken(code, manageTokens)
      }

      log.info('refreshing token')
      return this.client.refreshAccessToken(manageTokens)
    })
  }

  hasRefreshToken() {
    return this.tokens.google.refresh_token != null
  }
}

export class FacebookService extends OAuthProvider {
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
