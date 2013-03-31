jsFiles = [
  'src/init.js'
]

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    # Metadata.
    pkg: grunt.file.readJSON('package.json')
    buildDir: 'dist'
    banner: """
      /*!
       * <%= pkg.title || pkg.name %> <%= pkg.version %>
       * Last build: <%= grunt.template.today("yyyy-mm-dd") %>
       * <%= pkg.homepage %>
       * Copyright <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> and other contributors; Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %>
       */\n\n
    """

    # Task configuration.
    concat:
      options:
        banner: '<%= banner %>'
        stripBanners: true
      js:
        src: [jsFiles]
        dest: '<%= buildDir %>/x-sdk.js'
      jsmin:
        src: [jsFiles]
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
      src: jsFiles
      tests: ['test/*.js']
      gruntfile: ['Gruntfile.js']

    jasmine:
      js:
        src: jsFiles
        options:
          specs: 'test/*_spec.js'
          helpers: 'test/helpers/*'
          vendor: 'test/vendor/*'

    watch:
      js:
        files: jsFiles,
        tasks: 'build:js'

    exec:
      open_spec_runner:
        cmd: 'open _SpecRunner.html'

    clean:
      dist: 'dist'

  # Default task.
  grunt.registerTask 'default', 'build'
  grunt.registerTask 'build', ['concat:js', 'concat:jsmin', 'uglify']
  grunt.registerTask 'lint', 'jshint'
  grunt.registerTask 'test', 'jasmine:js'
  grunt.registerTask 'test:browser', ['jasmine:js:build', 'exec:open_spec_runner']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
