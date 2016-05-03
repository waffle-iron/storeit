gulp = require 'gulp'
browserSync = (require 'browser-sync').create()
cache = require 'gulp-cached'
nodeCLI = require 'shelljs-nodecli'
runSeq = require 'run-sequence'

SRC = './src/**'

gulp.task 'default', ['dev']

gulp.task 'build', (done) ->
  console.log 'build task: to do'
  done()

gulp.task 'dev', ['watch'], (done) ->
  # runSeq 'serve'
  done()

gulp.task 'serve', (done) ->
  nodeCLI.exec 'jspm', 'run', 'server.js'
  done()

gulp.task 'watch', (done) ->
  browserSync.init
    proxy: 'http://localhost:3000'
    files: SRC
    port: 8081
  gulp.watch SRC, browserSync.stream()
  done()
