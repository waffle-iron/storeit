import angular from 'angular'

import {html} from './app.jade!'
import './app.css!'

import components from './core/components.js'

const DEPENDENCIES = [
  components,
]

let appComponent = {
  template: html,
  $routeConfig: [
    {path: '/auth', name: 'Auth', component: 'auth', useAsDefault: true},
    {path: '/files', name: 'Files', component: 'filesView'},
  ],
}

export default angular.module('storeit.app', DEPENDENCIES)
  .component('app', appComponent)
  .name
