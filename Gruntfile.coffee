module.exports = (grunt) =>
	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')
		jade:
			compile:
				options:
					pretty: true
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
					'public/css/style.css': 'less/style.less'
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
					'coffee/**'
					'jade/**'
					'less/**'
					'public/**'
				]
				livereload:
					enabled: true
			"coffee": (path) ->
				['newer:coffee']
			"jade": (path) ->
				['newer:jade']
			"less": (path) ->
				['newer:less']
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

	grunt.loadNpmTasks 'grunt-rsync'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-bower-task'
	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-este-watch'
	grunt.loadNpmTasks 'grunt-newer'
	grunt.registerTask 'make', ['bower', 'newer:coffee', 'newer:jade', 'newer:less']
	grunt.registerTask 'dry-deploy', ['rsync:dryrun']
	grunt.registerTask 'deploy', ['rsync:deploy']
	grunt.registerTask 'default', ['make', 'connect', 'esteWatch']
