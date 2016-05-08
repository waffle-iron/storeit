import angular from 'angular'
import hello from 'hellojs'

import AuthController from './auth_controller.js'
import {html as template} from './auth.jade!'
import './auth.css!'

let authComponent = {
  template,
  controller: AuthController,
  controllerAs: 'vm',
}

let authConfig = (STOREIT) => {
  'ngInject'

  let credentials = {
    facebook: STOREIT.facebookId,
    google: STOREIT.googleId
  }
  let options = {
    /* eslint camelcase: "off" */
    redirect_uri: `${window.location.origin}/#/auth`
  }

  hello.init(credentials, options)
}

const DEPENDENCIES = []
export default angular.module('storeit.app.components.auth', DEPENDENCIES)
  .config(authConfig)
  .value('Facebook', hello('facebook'))
  .value('Google', hello('google'))
  .component('auth', authComponent)
  .name
