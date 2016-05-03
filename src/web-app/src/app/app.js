import angular from 'angular'
import 'ngComponentRouter'
import {html as template} from './app.jade!'
import './app.css!'

class AppController {}

export default angular.module('app', [])
  .component('app', {
    template,
    controller: AppController,
    controllerAs: 'vm',
  })
