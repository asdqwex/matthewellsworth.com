require './vendor/angular.js'
require './vendor/prism.js'
require './vendor/ui-bootstrap-0.12.0.min.js'

app = angular.module 'erulabs', ['ui.bootstrap']

app.controller 'blogController', ['$scope', '$sce', ($scope, $sce) ->
  $scope.isCollapsed = true;
  previewPostLength = 1012
  $scope.focus = false
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
      $scope.focus = yes
      return $sce.trustAsHtml(post.body)
    else
      if post.body.toString().length > previewPostLength
        $scope.focus = no
        post.preview = yes
        return $sce.trustAsHtml(post.blurb.toString())
      else
        $scope.focus = yes
        return $sce.trustAsHtml(post.body)

  $scope.flip = () ->
    document.body.className = 'transform'
    setTimeout () ->
      document.body.className = ''
    , 3000

  $scope.blog = [
    {
      title: 'Hello'
      body: require('./posts/welcome.html')
      blurb: """
      Welcome!
      """
      date: 'January 23th, 2015'
    }
    # {
    #   title: 'Prism.js'
    #   body: require('./posts/Prism.js.html')
    #   blurb: """
    #   A Demo of Prism JS
    #   """
    #   date: 'January 29th, 2015'
    # }
  ]
]
