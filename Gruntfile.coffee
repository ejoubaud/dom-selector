'use strict'

module.exports = (grunt)->

  # load all grunt tasks
  (require 'matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  _ = grunt.util._
  path = require 'path'

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffeelint:
      gruntfile:
        src: '<%= watch.gruntfile.files %>'
      lib:
        src: '<%= watch.lib.files %>'
      test:
        src: '<%= watch.test.files %>'
      options:
        no_trailing_whitespace:
          level: 'error'
        max_line_length:
          level: 'warn'
    browserify:
      lib:
        files: [
          expand: true
          cwd: 'src/lib'
          src: '*.coffee'
          dest: 'out/lib'
          ext: '.js'
        ]
        options:
          transform: ['coffeeify']
    coffee:
      test:
        expand: true
        cwd: 'src/test/'
        src: ['**/*.coffee']
        dest: 'out/test/'
        ext: '.js'
    stylus:
      style:
        files: [
          expand: true
          cwd: 'src/style/'
          src: ['*.styl']
          dest: 'out/style/'
          ext: '.css'
        ]
        options:
          compress: false
    simplemocha:
      all:
        src: [
          'node_modules/should/should.js'
          'out/test/**/*.js'
        ]
        options:
          globals: ['should']
          timeout: 3000
          ignoreLeaks: false
          ui: 'bdd'
          reporter: 'spec'
    watch:
      options:
        spawn: false
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['coffeelint:gruntfile']
      lib:
        files: ['src/lib/**/*.coffee']
        tasks: ['coffeelint:lib', 'browserify:lib', 'simplemocha']
      style:
        files: ['src/style/**/*.styl']
        tasks: ['stylus:style']
      test:
        files: ['src/test/**/*.coffee']
        tasks: ['coffeelint:test', 'coffee:test', 'simplemocha']
    clean: ['out/']

  # tasks.
  grunt.registerTask 'compile', [
    'coffeelint'
    'stylus'
    'browserify'
  ]

  grunt.registerTask 'test', [
    'simplemocha'
  ]

  grunt.registerTask 'default', [
    'compile'
    'test'
  ]

