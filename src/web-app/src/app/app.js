import angular from 'angular'

import AppController from './app_controller.js'
import {html} from './app.jade!'
import './app.css!'

import components from './core/components.js'

const DEPENDENCIES = [
  components,
]

let appComponent = {
  template: html,
  controller: AppController,
  controllerAs: 'vm',
  $routeConfig: [
    {path: '/auth', name: 'Auth', component: 'auth', useAsDefault: true},
  ],
}

export default angular.module('storeit.app', DEPENDENCIES)
  .component('app', appComponent)
  .name
