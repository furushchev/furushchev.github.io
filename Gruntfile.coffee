module.exports = (grunt) =>
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    image:
      dynamic:
        files: [
          expand: true
          cwd: 'static/img'
          src: ['**/*.{png,jpg,gif,svg}']
          dest: 'public/img/'
        ]
    copy:
      main:
        files: [
          expand: true
          cwd: 'static'
          src: ['**/*', '!img/**', '!**/*~']
          dest: 'public'
        ]
    jade:
      compile:
        options:
          pretty: true
          data:
            hostname: 'furushchev.ru'
        files: [
          expand: true
          cwd: 'jade'
          src: ['*.jade']
          dest: 'public/'
          ext: '.html'
        ]
    less:
      dist:
        options:
          compress:
            true
          paths:
            ['public/lib/css']
        files: [
          expand: true
          cwd: 'less'
          src: ['**/*.less']
          dest: 'public/css'
          ext: '.css'
        ]
    coffee:
      compile:
        options:
          bare: true
        files: [
          expand: true
          cwd: 'coffee'
          src: ['**/*.coffee']
          dest: 'public/js'
          ext: '.js'
        ]
    bower:
      install:
        options:
          targetDir: 'public/lib'
          layout: 'byType'
          install: true
          cleanTargetDir: true
          cleanBowerDir: false
    connect:
      server:
        options:
          port: 3000
          hostname: '*'
          base: 'public'
          livereload: 35729
    esteWatch:
      options:
        dirs: [
          'coffee/**/'
          'jade/**/'
          'less/**/'
          'static/**/'
          'public/**/'
        ]
        livereload:
          enabled: true
      "coffee": (path) ->
        ['newer:coffee']
      "jade": (path) ->
        ['newer:jade']
      "less": (path) ->
        ['newer:less']
      "jpg": (path) ->
        ['newer:image']
      "png": (path) ->
        ['newer:image']
      "svg": (path) ->
        ['newer:image']
    rsync:
      options:
        src: "public/"
        args: ["--verbose"]
        recursive: true
        compareMode: "checksum"
      dryrun:
        options:
          dest: "~/public_html"
          host: "furushchev@aries+www"
          syncDestIgnoreExcl: true
          dryRun: true
      deploy:
        options:
          dest: "~/public_html"
          host: "furushchev@aries+www"
          syncDestIgnoreExcl: true
    "gh-pages":
      options:
        base: "public"
        branch: "master"
      publish:
        options:
          repo: "https://github.com/furushchev/furushchev.github.io.git"
        src: '**/*'
      deploy:
        src: '**/*'
        options:
          user:
            name: "Yuki Furuta"
            email: "furushchev@jsk.imi.i.u-tokyo.ac.jp"
          repo: "https://" + process.env.GH_TOKEN + "@github.com/furushchev/furushchev.github.io.git"
          silent: false
  grunt.loadNpmTasks 'grunt-rsync'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-image'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-gh-pages'
  grunt.registerTask 'check-deploy', () ->
    if process.env.TRAVIS is 'true' and process.env.TRAVIS_SECURE_ENV_VARS is 'true' and process.env.TRAVIS_PULL_REQUEST is 'false'
      grunt.log.writeln "deploying..."
      grunt.task.run 'gh-pages:deploy'
    else
      grunt.log.writeln "skip deploy..."
  grunt.registerTask 'make', ['bower', 'newer:copy', 'newer:image', 'newer:coffee', 'newer:jade', 'newer:less']
  grunt.registerTask 'dry-deploy', ['rsync:dryrun']
  grunt.registerTask 'gh-deploy', ['make', 'gh-pages']
  grunt.registerTask 'gh-deploy-travis', ['make', 'check-deploy']
  grunt.registerTask 'deploy', ['make', 'rsync:deploy', 'gh-pages']
  grunt.registerTask 'default', ['make', 'connect', 'esteWatch']
