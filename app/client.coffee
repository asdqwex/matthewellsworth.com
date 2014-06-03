require('./vendor/angular.js');

app = angular.module 'erulabs', []

app.controller 'blogController', ['$scope', ($scope) ->
	previewPostLength = 1000
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
		req = getPostReq()
		if req is post.title
			return post.body
		else
			if post.body.length > previewPostLength
				post.body.substr 0, previewPostLength + '...'
			else
				return post.body

	$scope.blog = [
		{
			title: 'Developing and deploying static sites with GulpJS and the Cloud'
			body: require('./posts/Developing-and-deploying-static-sites-with-GulpJS-and-the-Cloud.html')
		}
	]
]