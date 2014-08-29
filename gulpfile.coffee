gulp = require('gulp')
rename = require('gulp-rename')
lint = require('gulp-coffeelint')
stylus = require('gulp-stylus')
mocha = require('gulp-mocha')
nib = require('nib')
browserify = require('browserify')
transform = require('vinyl-transform')

paths =
  lib: 'src/lib/**/*.coffee'
  style: 'src/style/**/*.styl'

gulp.task 'default', ['test', 'compile']
gulp.task 'compile', ['lib', 'stylus']
gulp.task 'lib', ['lint', 'coffee']
gulp.task 'style', ['stylus']
gulp.task 'test', ['lint', 'mocha']

gulp.task 'lint', ->
  gulp.src(paths.lib)
    .pipe lint
      no_trailing_whitespace:
        level: 'error'
      max_line_length:
        level: 'warn'
    .pipe(lint.reporter())
    .pipe(lint.reporter('fail'))

gulp.task 'coffee', ->
  gulp.src('src/lib/*.coffee')
    .pipe transform (path) ->
      browserify(path, extensions: '.coffee')
        .transform('coffeeify')
        .bundle()
    .pipe(rename(extname: ".js"))
    .pipe(gulp.dest('out/lib'))

gulp.task 'stylus', ->
  gulp.src('src/style/*.styl')
    .pipe(stylus(use: [nib()]))
    .pipe(rename(extname: '.css'))
    .pipe(gulp.dest('out/style'))

gulp.task 'mocha', ->
  gulp.src('src/test/**/*.coffee')
    .pipe(mocha())

gulp.task 'watch', ->
  gulp.watch(paths.lib, ['lib'])
  gulp.watch(paths.style, ['style'])
