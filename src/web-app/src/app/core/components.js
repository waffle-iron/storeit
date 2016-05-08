import angular from 'angular'

import auth from '../components/auth/auth.js'

const COMPONENTS = [
  auth,
]

export default angular.module('storeit.app.components', COMPONENTS).name
