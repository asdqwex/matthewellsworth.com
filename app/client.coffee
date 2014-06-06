require('./vendor/angular.js');

app = angular.module 'erulabs', []

app.controller 'blogController', ['$scope', '$sce', ($scope, $sce) ->
	previewPostLength = 512
	getPostReq = () ->
		postTitleReq = !!window.location.href.split('/posts/')[1]
		if postTitleReq? and postTitleReq
			return window.location.href.split('#')[0].split('/posts/')[1].replace(/\-/g, ' ')
		else
			return false
	$scope.urlify = (string) ->
		return string.replace(/\-/g, ' ').replace(/\:/g, ' ').replace(/\ /g, '_')
	$scope.urlFilter = (post) ->
		req = getPostReq()
		if req
			if $scope.urlify(req) is $scope.urlify(post.title)
				return true
			else
				return false
		else
			return true
	$scope.bodyFilter = (post) ->
		if !post.body?
			return "Default Body"
		req = getPostReq()
		post.preview = no
		if req is $scope.urlify(post.title)
			return $sce.trustAsHtml(post.body)
		else
			if post.body.toString().length > previewPostLength
				post.preview = yes
				return $sce.trustAsHtml(post.body.toString().substr(0, previewPostLength))
			else
				return $sce.trustAsHtml(post.body)

	$scope.blog = [
		{
			title: 'PerfectStack: NodeJS Salt and the Cloud - Part 1: Static sites'
			body: require('./posts/Developing-and-deploying-static-sites-with-GulpJS-and-the-Cloud.html')
			date: 'June 5th, 2014'
		}
	]
]