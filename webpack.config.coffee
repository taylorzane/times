path = require 'path'
webpack = require 'webpack'

module.exports =
  entry: './src/main'
  output:
    path: './dist'
    filename: 'main.js'
  target: 'node-webkit'
  module:
    loaders: [
      test: /\.coffee$/, loader: 'coffee'
    ,
      test: /\.css$/, loader: 'style!css'
    ,
      test: /\.scss$/, loader: 'style!css!autoprefixer!sass'
    ,
      test: /\.jade$/, loader: 'jade'
    ,
      test: /\.json$/, loader: 'json'
    ]
  resolve:
    modulesDirectories: ['src', 'node_modules', 'bower_components']
    extensions: ['', '.coffee', '.js', '.json']
  node:
    fs: 'empty'
  # plugins: [
  #   # NOTE: This provides the ability to only require certain locales.
  #   new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /a^/)
  # ]
