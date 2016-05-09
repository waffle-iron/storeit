import angular from 'angular'

import FileExplorerController from './file_explorer_controller.js'
import {html as template} from './file_explorer.jade!'
import './file_explorer.css!'

let fileExplorerComponent = {
  template,
  controller: FileExplorerController,
  controllerAs: 'vm',
}

const DEPENDENCIES = []
export default angular.module('storeit.app.file-explorer', DEPENDENCIES)
  .component('fileExplorer', fileExplorerComponent)
  .name
