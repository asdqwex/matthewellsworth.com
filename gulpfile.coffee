'use strict'
gulp       = require 'gulp'
gp         = (require 'gulp-load-plugins') lazy: no
path       = require 'path'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
cloudfiles = require 'gulp-cloudfiles'
rackspace  = 
	username: 'seandon'
	apiKey: 'd197727875ad413198fd341d5d70d434'
	region: 'DFW'
rackspace.container = if process.argv[3]? then process.argv[3] else 'live'
deployOptions =
	deplay: 0
	uploadPath: ""
deploy = if process.argv[2] is 'deploy' then yes else no

gulp.task 'clientBundle', ->
	stream = browserify({
			entries: [ './app/client.coffee' ]
			extensions: [ '.coffee', '.js' ]
		})
		.transform 'coffeeify'
		.bundle()
		.pipe source 'bundle.js'
		.pipe gulp.dest 'dist'
		.pipe gp.rename 'bundle.js'
	if deploy
		stream.pipe cloudfiles rackspace, deployOptions

gulp.task 'html', ->
	stream = gulp.src 'app/index.jade'
		.pipe gp.plumber()
		.pipe gp.jade()
		.pipe gulp.dest 'dist'
		.pipe gp.rename 'index.html'
	if deploy
		stream.pipe cloudfiles rackspace, deployOptions

gulp.task 'style', ->
	stream = gulp.src 'app/style/**/*'
		.pipe gp.plumber()
		.pipe gp.concat('bundle.css')
		.pipe gp.cssmin keepSpecialComments: 0
		.pipe gulp.dest 'dist'
		.pipe gp.rename 'bundle.css'
	if deploy
		stream.pipe cloudfiles rackspace, deployOptions

gulp.task 'assets', ->
	stream = gulp.src 'app/assets/**/*'
		.pipe gulp.dest 'dist/assets'
	if deploy
		stream.pipe cloudfiles rackspace, { uploadPath: 'assets/' }

gulp.task 'build', [ 'clientBundle', 'html', 'style', 'assets' ]

gulp.task 'default', [ 'build' ]

gulp.task 'deploy', [ 'build' ]

gulp.task 'connect', [ 'default' ], ->
	gp.connect.server
		root: 'dist'
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
				reloadasset = 'bundle.js'
			when '.sass', '.css'
				taskname = 'Style'
				reloadasset = 'bundle.css'
			when '.jade'
				taskname = 'HTML'
				reloadasset = 'index.html'

		gulp.task 'clientReload', [taskname], ->
			gulp.src 'dist/' + reloadasset
				.pipe gp.connect.reload()

		gulp.start 'clientReload'

