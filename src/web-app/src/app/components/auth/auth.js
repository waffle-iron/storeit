import angular from 'angular'
import 'ngComponentRouter'
import {html as template} from './auth.jade!'
import './auth.css!'

class AuthController
{

}

const DEPENDENCIES = [
  'ngComponentRouter',
]

export default angular.module('app.components.auth', DEPENDENCIES)
  .component('auth', {
    template,
    controller: AuthController,
    controllerAs: 'vm',
  })
