import {FacebookService, GoogleService} from './oauth'

let storeitAuth = () => {
  throw {msg: 'StoreIt auth not implemented yet'}
}

let auth = (type) => {
  let extern = null
  switch (type) {
  case 'facebook':
    extern = new FacebookService()
    return extern.oauth()
    break
  case 'google':
    extern = new GoogleService()
    return extern.oauth()
    break
  default:
    return storeitAuth()
  }
}

export default auth
