import 'systemjs-hot-reloader/default-listener'
import angular from 'angular'

import app from './app/app.js'

let appContainer = document.getElementById('app-container')
let containerClone

angular.element(document).ready(() => {
  containerClone = appContainer.cloneNode(true)
  angular.bootstrap(appContainer, [app.name])
})

// FIXME
export let __unload = () => {
  appContainer = document.getElementById('app-container')
  appContainer.remove()
  document.body.appendChild(containerClone.cloneNode(true))
}
