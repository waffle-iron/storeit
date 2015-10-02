gulp        = require 'gulp'
concat      = require 'gulp-concat'
notify      = require 'gulp-notify'
rm          = require 'del'

jshint      = require 'gulp-jshint'
jscs        = require 'gulp-jscs'
minify      = require 'gulp-uglify'
sourcemaps  = require 'gulp-sourcemaps'
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
        .pipe sourcemaps.init()
            .pipe transpile()
            .pipe concat config.main
            # .pipe minify()
        .pipe sourcemaps.write '.'
        .pipe gulp.dest config.dist
        .pipe notify
            onLast: true
            message: 'JavaScript files compiled'

gulp.task 'data-copy', ->
    gulp.src "#{config.srcsPath}/data/**"
        .pipe gulp.dest "#{config.dist}/data"

gulp.task 'watch', ->
    gulp.watch config.srcs, ['build']

gulp.task 'clean', ->
    rm ["#{config.dist}/#{config.main}"]

gulp.task 'fclean', ->
    rm [config.dist]

gulp.task 're', ['fclean', 'install']
