coffeeFiles = [
  'src/init.coffee'
]

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    # Metadata.
    pkg: grunt.file.readJSON('package.json')
    buildDir: 'dist'
    compileDir: 'compile'
    banner: """
      /*!
       * <%= pkg.title || pkg.name %> <%= pkg.version %>
       * Last build: <%= grunt.template.today("yyyy-mm-dd") %>
       * <%= pkg.homepage %>
       * Copyright <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> and other contributors; Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %>
       */\n\n
    """

    # Task configuration.

    coffee:
      options:
        join: true
        bare: false
      compile:
        src: [coffeeFiles]
        dest: '<%= compileDir %>/compiled.js'

    concat:
      options:
        banner: '<%= banner %>'
        stripBanners: true
      js:
        src: '<%= coffee.compile.dest %>'
        dest: '<%= buildDir %>/x-sdk.js'
      jsmin:
        src: '<%= coffee.compile.dest %>'
        dest: '<%= buildDir %>/x-sdk.min.js'

    uglify:
      options:
        banner: "<%= banner %>"
      js:
        options:
          mangle: false
          beautify: true
          compress: false
        src: '<%= concat.js.dest %>'
        dest: '<%= concat.js.dest %>'
      jsmin:
        options:
          mangle: true
          compress: true
        src: '<%= concat.jsmin.dest %>'
        dest: '<%= concat.jsmin.dest %>'

    jshint:
      options:
        jshintrc: '.jshintrc'
      src: '<%= concat.js.dest %>'
      tests: ['test/*.js']
      gruntfile: ['Gruntfile.js']

    jasmine:
      js:
        src: '<%= concat.js.dest %>'
        options:
          specs: 'test/*_spec.js'
          helpers: 'test/helpers/*'
          vendor: 'test/vendor/*'

    watch:
      js:
        files: [coffeeFiles],
        tasks: 'build:js'

    exec:
      open_spec_runner:
        cmd: 'open _SpecRunner.html'

    clean:
      dist: ['compile', 'dist']

  # Default task.
  grunt.registerTask 'default', 'build'
  grunt.registerTask 'build', ['coffee:compile', 'concat:js', 'concat:jsmin', 'uglify']
  grunt.registerTask 'lint', ['build', 'jshint']
  grunt.registerTask 'test', ['build', 'jasmine:js']
  grunt.registerTask 'test:browser', ['build', 'jasmine:js:build', 'exec:open_spec_runner']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
