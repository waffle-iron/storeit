gulp        = require 'gulp'
# concat      = require 'gulp-concat'
notify      = require 'gulp-notify'
pipeIf      = require 'gulp-if-else'
pipeWrapper = require 'gulp-plumber'
# rename      = require 'gulp-rename'
rm          = require 'del'

jshint      = require 'gulp-jshint'
jscs        = require 'gulp-jscs'
# minify      = require 'gulp-uglify'
sourcemaps  = require 'gulp-sourcemaps'
transpile   = require 'gulp-babel'

config      = require './.gulpconfig'
config.srcs = "#{config.srcsPath}/#{config.srcsPattern}"

gulp.task 'default',
    if config.dev is true
    then ['build', 'watch']
    else ['build']

gulp.task 'install', ['build', 'data-copy']

gulp.task 'build', ['lint'], ->
    gulp.src config.srcs
        .pipe pipeWrapper()
        .pipe sourcemaps.init()
            .pipe transpile optional: ['runtime']
            # .pipe minify()
        .pipe sourcemaps.write '.'
        .pipe gulp.dest config.dist
        .pipe pipeIf(config.notify, -> notify
            onLast: true
            message: 'JavaScript files compiled')

gulp.task 'lint', ->
    gulp.src config.srcs
        .pipe pipeWrapper()
        .pipe jshint('.jshintrc')
        .pipe(jshint.reporter('jshint-stylish'))
        # .pipe(jshint.reporter('fail'))
        # .pipe jscs()
        # .pipe jscs.reporter()

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
