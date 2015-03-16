require './vendor/angular.js'
require './vendor/prism.js'
require './vendor/ui-bootstrap-0.12.0.min.js'

app = angular.module 'matthewellsworth', ['ui.bootstrap']

app.controller 'blogController', ['$scope', '$sce', ($scope, $sce) ->
  $scope.isCollapsed = true;
  previewPostLength = 10
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
      title: 'Automatic code deployment with Github Webhooks and saltStack'
      body: require('./posts/webhooks.html')
      blurb: """
      <pre>
        <code class="language-bash">\_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_
      Pushing to my git repo\n
      triggers a webhook\n
      that runs salt\n
      to update this website
      \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_</code>
      </pre><br>
      """
      date: 'March 5th, 2015'
    }
    {
      title: 'Deploying our Demo Rails application'
      body: require('./posts/application.html')
      blurb: """
      <pre>
        <code class="language-bash">\_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_
      A pinch of Ansible\n
      One dash of git\n
      Put it in the oven for 15 minutes\n
      And out comes Devops
      \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_</code>
      </pre><br>
      """
      date: 'March 25th, 2015'
    }
    {
      title: 'Creating a cloud server with Javascript'
      body: require('./posts/newServerRacksjs.html')
      blurb: """
      <pre>
        <code class="language-bash">\_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_
      Javascript?\n
      As an Automation tool?\n
      You Crazy!
      \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_</code>
      </pre><br>
      """
      date: 'March 4th, 2015'
    }
    {
      title: 'Demo Rails application'
      body: require('./posts/rails.html')
      blurb: """
      <pre>
        <code class="language-bash">\_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_
      I needed a rails application to test a deployment with.\n
      Here is how I did it.\n
      You can copy paste these commands!
      \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_</code>
      </pre><br>
      """
      date: 'February 25th, 2015'
    }
    {
      title: 'Matthew the Lover, Fighter and Philanthropist'
      body: require('./posts/welcome.html')
      blurb: """
      <pre>
        <code class="language-bash">\_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_
      Let me tell yout a litte bit about me,\n
      This site and the technology it uses,\n
      And why you should be reading it.
      \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_</code>
      </pre><br>
      """
      date: 'January 23th, 2015'
    }
  ]
]
