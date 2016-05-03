gulp = require 'gulp'
browserSync = (require 'browser-sync').create()
cache = require 'gulp-cached'
runSeq = require 'run-sequence'

SRC = './src/**'

gulp.task 'default', ['dev']

gulp.task 'build', (done) ->
  console.log 'build task: to do'
  done()

gulp.task 'dev', (done) ->
  browserSync.init
    proxy: 'http://localhost:3000'
    files: SRC
    port: 8080
  gulp.watch SRC, browserSync.stream()
  done()
