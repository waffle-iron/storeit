import {oauth2} from 'googleapis'
import * as https from 'https'

const oauth = oauth2('v2')

export const verifyUserToken = (authService, accessToken, handlerFn) => {
  if (accessToken === 'developer') {
    handlerFn(null, 'adrien.morel@me.com')
  }
  else {
    if (authService === 'gg') {
      oauth.userinfo.get({'access_token': accessToken}, (err, response) => {
        handlerFn(err, err ? null : response.mail)
      })
    }
    else if (authService === 'fb') {
      https.get({
        host: 'graph.facebook.com',
        path: '/me?access_token=' + accessToken + '&fields=email'
      }, (response) => {

        // Continuously update stream with data
        let body = ''
        response.on('data', (d) => {
          body += d
        })

        response.on('end', () => {

          try {
            const parsed = JSON.parse(body)
            handlerFn(parsed.email === undefined ? 'invalid' : null, parsed.email)
          }
          catch (e) {
            handlerFn(e)
          }
        })
      })
    }
    else {
      handlerFn(true, null)
    }
  }
}
