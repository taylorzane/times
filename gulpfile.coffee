gulp = require 'gulp'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
webpack = require 'webpack'
fs = require 'fs'
plumber = require 'gulp-plumber'
nwBuilder = require 'nw-builder'


webpackConfig = require './webpack.config.coffee'

# Watcher
gulp.task 'watch', ['build'], (done) ->
  # Jade
  gulp.watch './src/**/*.jade', ['jade']

  # Webpack
  gulp.watch './src/**/*.coffee', ['webpack']
  gulp.watch './src/**/*.scss', ['webpack']

  done()

# Build
gulp.task 'build', ['webpack', 'jade']

# Package
gulp.task 'package', (done) ->
  nw = new nwBuilder(
    files: ['./dist/**/**', './package.json'],
    platforms: ['osx32', 'osx64', 'win32', 'win64']
    buildDir: './build'
    appName: 'times'
    buildType: 'timestamped'

  )

  # //Log stuff you want

  nw.on('log',  gutil.log);

  # // Build returns a promise
  nw.build().then(() ->
    console.log('all done!')
  ).catch((error) ->
    console.error(error)
  )

# Webpack
gulp.task 'webpack', (done) ->
  webpack webpackConfig, (error, stats) ->
    if error
      throw new gutil.PluginError 'webpack', error

    gutil.log '[webpack]', stats.toString()

  done()

# Jade
gulp.task 'jade', (done) ->
  gulp.src './src/*.jade', base: 'src'
    .pipe plumber()
    .pipe jade pretty: true, locals: { web: true }
    .pipe gulp.dest './dist'

  done()
