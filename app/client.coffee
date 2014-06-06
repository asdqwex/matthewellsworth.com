require('./vendor/angular.js');

app = angular.module 'erulabs', []

app.controller 'blogController', ['$scope', '$sce', ($scope, $sce) ->
	previewPostLength = 500
	getPostReq = () ->
		postTitleReq = !!window.location.href.split('/posts/')[1]
		if postTitleReq? and postTitleReq
			return window.location.href.split('#')[0].split('/posts/')[1].replace(/\-/g, ' ')
		else
			return false
	$scope.urlFilter = (post) ->
		req = getPostReq()
		if req
			if req is post.title
				return true
			else
				return false
		else
			return true
	$scope.bodyFilter = (post) ->
		if !post.body?
			return "Default Body"
		req = getPostReq()
		if req is post.title
			return post.body
		else
			if post.body.length > previewPostLength
				return post.body.substr(0, previewPostLength) + '...'
			else
				return post.body

	$scope.blog = [
		{
			title: 'PerfectStack: NodeJS Salt and the Cloud - Part 1: Static sites'
			body: $sce.trustAsHtml(require('./posts/Developing-and-deploying-static-sites-with-GulpJS-and-the-Cloud.html'))
			date: 'June 5th, 2014'
		}
	]
]