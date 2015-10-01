gulp        = require 'gulp'
concat      = require 'gulp-concat'
notify      = require 'gulp-notify'
rm          = require 'del'

jshint      = require 'gulp-jshint'
jscs        = require 'gulp-jscs'
minify      = require 'gulp-uglify'
transpile   = require 'gulp-babel'

config      = require './config.json'


gulp.task 'default',
    if config.dev is true
    then ['build', 'watch']
    else ['build']

gulp.task 'build', ->
    gulp.src config.src
        .pipe jshint()
        .pipe jscs()
        .pipe transpile()
        .pipe concat config.dest
        .pipe gulp.dest '.'
        .pipe notify 'JavaScript files compiled'

gulp.task 'watch', ->
    gulp.watch config.src, ['re']

gulp.task 'clean', ->
    rm [config.dest]

gulp.task 're', ['clean', 'default']
