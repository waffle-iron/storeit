export default class FileExplorerController {
  constructor(FilesService, $scope) {
    'ngInject'

    this.scope = $scope
    FilesService.getFiles()
      .then((files) => {
        console.log(files)
        this.path = []
        this.cwd = files
        this.scope.$apply()
      })
  }

  action(index) {
    if (this.cwd[index].kind === 'dir') {
      this.cd(index)
    }
  }

  cd(index) {
    this.path.push(this.cwd)
    this.cwd = this.cwd[index].files
    console.log('cd', this.cwd[index])
  }

  parent() {
    let prev = this.path.pop()
    this.cwd = prev
  }
}
