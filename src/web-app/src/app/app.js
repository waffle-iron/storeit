import angular from 'angular'
import 'ngComponentRouter'

import {html as template} from './app.jade!'
import './app.css!'

import components from './core/components.js'

let appConfig = ($locationProvider) => {
  'ngInject'
  $locationProvider.html5Mode(false) // TODO
}

class AppController {}

const DEPENDENCIES = [
  'ngComponentRouter',
  components.name,
]

export default angular.module('app', DEPENDENCIES)
  .value('$routerRootComponent', 'app')
  .config(appConfig)
  .component('app', {
    template,
    controller: AppController,
    controllerAs: 'vm',
    $routeConfig: [
      {path: '/auth', name: 'Auth', component: 'auth', useAsDefault: true},
    ],
  })
