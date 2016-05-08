import angular from 'angular'
import AuthController from './auth_controller.js'
import {html as template} from './auth.jade!'
import './auth.css!'

let authComponent = {
  template,
  controller: AuthController,
  controllerAs: 'vm',
  // require: {
  //   appCtrl: '^' + 'app'
  // }
}

const DEPENDENCIES = []
export default angular.module('storeit.app.components.auth', DEPENDENCIES)
  .component('auth', authComponent)
  .name
