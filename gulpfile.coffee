'use strict'
gulp       = require 'gulp'
gp         = (require 'gulp-load-plugins') lazy: no
path       = require 'path'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'

gulp.task 'clientBundle', ->
	browserify
		entries: [ './app/client.coffee' ]
		extensions: [ '.coffee', '.js' ]
	.transform 'coffeeify'
	.bundle()
	.pipe source 'bundle.js'
	.pipe gulp.dest 'dist'

gulp.task 'HTML', ->
	gulp.src 'app/index.jade'
		.pipe gp.plumber()
		.pipe gp.jade()
		.pipe gulp.dest 'dist/client'

gulp.task 'Style', ->
	gulp.src 'app/style/**/*'
		.pipe gp.plumber()
		.pipe gp.concat('bundle.css')
		.pipe gp.cssmin keepSpecialComments: 0
		.pipe gulp.dest 'dist/style'

gulp.task 'Assets', ->
	gulp.src 'app/assets/**/*'
		.pipe gulp.dest 'dist/assets'

gulp.task 'build', [ 'clientBundle', 'HTML', 'Style', 'Assets' ]

gulp.task 'default', [ 'build' ]

gulp.task 'connect', [ 'default' ], ->
	gp.connect.server
		root: 'dist/client'
		port: 9000
		livereload: yes

gulp.task 'watch', [ 'connect' ], ->
	gulp.watch 'app/**/*', read: false, (event) ->
		ext = path.extname event.path
		taskname = null
		reloadasset = null
		switch ext
			when '.coffee', '.js'
				taskname = 'clientBundle'
				reloadasset = 'app.js'
			when '.sass', '.css'
				taskname = 'Style'
				reloadasset = 'style/site.css'
			when '.jade'
				taskname = 'HTML'
				reloadasset = 'index.html'

		gulp.task 'clientReload', [taskname], ->
			gulp.src 'dist/' + reloadasset
				.pipe gp.connect.reload()

		gulp.start 'clientReload'

