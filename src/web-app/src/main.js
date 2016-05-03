import angular from 'angular'

import app from './app/app.js'

let appContainer = document.getElementById('app-container')
angular.element(document).ready(() => {
  angular.bootstrap(appContainer, [app.name])
})

export default app
