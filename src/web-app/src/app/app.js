import angular from 'angular'
import 'ngComponentRouter'
import {html as template} from './app.jade!'
import './app.css!'

let appConfig = ($locationProvider) => {
  'ngInject'

  $locationProvider.html5Mode(false) // TODO
}

class AppController {}

export default angular.module('app', ['ngComponentRouter'])
  .config(appConfig)
  .value('$routerRootComponent', 'app')
  .component('app', {
    template,
    controller: AppController,
    controllerAs: 'vm',
  })
