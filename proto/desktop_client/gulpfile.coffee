gulp        = require 'gulp'
concat      = require 'gulp-concat'
notify      = require 'gulp-notify'
rm          = require 'del'

jshint      = require 'gulp-jshint'
jscs        = require 'gulp-jscs'
minify      = require 'gulp-uglify'
transpile   = require 'gulp-babel'

config      = require './config.json'
config.srcs = "#{config.srcsPath}/#{config.srcsPattern}"

gulp.task 'default',
    if config.dev is true
    then ['build', 'watch']
    else ['build']

gulp.task 'install', ['build', 'data-copy']

gulp.task 'build', ->
    gulp.src config.srcs
        .pipe jshint()
        .pipe jscs()
        .pipe transpile()
        .pipe concat config.main
        .pipe gulp.dest config.dist
        .pipe notify 'JavaScript files compiled'

gulp.task 'data-copy', ->
    gulp.src "#{config.srcsPath}/data"
        .pipe gulp.dest config.dist

gulp.task 'watch', ->
    gulp.watch config.srcs, ['re']

gulp.task 'clean', ->
    rm [config.dist]

gulp.task 're', ['clean', 'default']
