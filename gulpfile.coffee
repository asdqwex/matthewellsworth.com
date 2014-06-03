'use strict'
gulp       = require 'gulp'
gutil      = require 'gulp-util'
gp         = (require 'gulp-load-plugins') lazy: no
path       = require 'path'
fs         = require 'fs'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
cloudfiles = require 'gulp-cloudfiles'
rewrite    = require 'connect-modrewrite'
stringify  = require 'stringify'
rackspace  = 
	username: 'seandon'
	apiKey: 'd197727875ad413198fd341d5d70d434'
	region: 'DFW'
rackspace.container = if process.argv[3]? then process.argv[3] else 'live'
deployOptions =
	delay: 0
	uploadPath: ""
deploy = if process.argv[2] is 'deploy' then yes else no
if deploy
	assetURL = 'http://static.erulabs.com/'
else
	assetURL = '/'

gulp.task 'clientBundle', ->
	stream = browserify({
			entries: [ './app/client.coffee' ]
			extensions: [ '.coffee', '.js' ]
		})
		.transform stringify [ '.html' ]
		.transform 'coffeeify'
		.bundle()
		.pipe source 'bundle.js'
		.pipe gulp.dest 'dist/assets'
	if deploy
		stream.pipe cloudfiles rackspace, deployOptions
	stream.on 'error', gutil.log

gulp.task 'html', ->
	stream = gulp.src 'app/index.jade'
		.pipe gp.plumber()
		.pipe gp.jade({
			locals:
				assetURL: assetURL
		})
		.pipe gulp.dest 'dist'
		.pipe gp.rename 'index.html'
	if deploy
		stream.pipe cloudfiles rackspace, deployOptions
	stream.on 'error', gutil.log

gulp.task 'style', ->
	stream = gulp.src 'app/style/site.less'
		.pipe gp.plumber()
		.pipe gp.less({
			compress: deploy
			rootpath: assetURL
		})
		.pipe gp.rename 'bundle.css'
		.pipe gulp.dest 'dist/assets'
	if deploy
		stream.pipe cloudfiles rackspace, deployOptions
	stream.on 'error', gutil.log

gulp.task 'assets', ->
	stream = gulp.src 'app/assets/**/*'
		.pipe gulp.dest 'dist/assets'
	if deploy
		stream.pipe cloudfiles rackspace, { uploadPath: '' }
	stream.on 'error', gutil.log

gulp.task 'build', [ 'clientBundle', 'html', 'style', 'assets' ]

gulp.task 'default', [ 'build' ]

gulp.task 'deploy', [ 'build' ]

gulp.task 'connect', [ 'default' ], ->
	gp.connect.server
		root: 'dist'
		port: 9000
		livereload: yes
		middleware: () ->
			return [
				rewrite([
					'^/posts/.* /index.html'
				])
			]

gulp.task 'watch', [ 'connect' ], ->
	gulp.watch 'app/**/*', read: false, (event) ->
		ext = path.extname event.path
		taskname = null
		reloadasset = null
		switch ext
			when '.coffee', '.js', '.html'
				taskname = 'clientBundle'
				reloadasset = 'assets/bundle.js'
			when '.less'
				taskname = 'style'
				reloadasset = 'assets/bundle.css'
			when '.jade'
				taskname = 'html'
				reloadasset = 'index.html'
		if taskname?
			gulp.task 'clientReload', [taskname], ->
				gulp.src 'dist/' + reloadasset
					.pipe gp.connect.reload()

			gulp.start 'clientReload'

