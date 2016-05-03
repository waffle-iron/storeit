import angular from 'angular'
import 'ngComponentRouter'
import {html as template} from './app.jade!'
import './app.css!'

let appConfig = () => {}

let appRun = () => {}

class AppController {}

export default angular.module('app', [])
  .config(appConfig)
  .run(appRun)
  .component('app', {
    template,
    controller: AppController,
    controllerAs: 'vm',
  })
