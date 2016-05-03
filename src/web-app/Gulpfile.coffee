gulp = require 'gulp'
livereload = require 'gulp-livereload'
cache = require 'gulp-cached'
nodeCLI = require 'shelljs-nodecli'

SRC = './src/**'

gulp.task 'default', ['dev']

gulp.task 'build', (done) ->
  console.log 'build task: to do'
  done()

gulp.task 'dev', ['watch', 'serve']

gulp.task 'serve', (done) ->
  nodeCLI.exec 'jspm', 'run', 'server.js'
  done()

gulp.task 'watch', (done) ->
  livereload.listen basePath: 'src'
  gulp.watch SRC, ['livereload']
  done()

gulp.task 'livereload', ->
  gulp.src SRC
    .pipe cache('livereload')
    .pipe livereload()
