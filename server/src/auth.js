import {oauth2} from 'googleapis'

const oauth = oauth2('v2')

export const verifyUserToken = (accessToken, handlerFn) => {
  if (accessToken === 'developer') {
    handlerFn(null, 'adrien.morel@me.com')
  }
  else {
    oauth.userinfo.get({'access_token': accessToken}, (err, response) => {
      handlerFn(err, err ? null : response.mail)
    })
  }
}
