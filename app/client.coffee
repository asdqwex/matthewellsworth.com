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
      title: 'Github Commits: Public vs Private'
      body: require('./posts/github-contrib.html')
      blurb: """
      <pre>
        <code class="language-bash">
      Careful when you link someone your github page\n
      If you do a lot of work in private repos you might look like a scrub\n
      I write code everyday I swear
      </code>
      </pre><br>
      """
      date: 'May 24th, 2015'
    }
    {
      title: 'Practice, Practice, Practice'
      body: require('./posts/practice.html')
      blurb: """
      <pre>
        <code class="language-bash">
      I found out about project euler the other day\n
      Lots of fun to be had practicing programming\n
      https://projecteuler.net
      </code>
      </pre><br>
      """
      date: 'May 15th, 2015'
    }
    {
      title: 'WorkInProgress: Ansible Tower'
      body: require('./posts/ansible-tower.html')
      blurb: """
      <pre>
        <code class="language-bash">
      Ansible Tower\n
      The web GUI for Ansible\n
      Installation and use
      </code>
      </pre><br>
      """
      date: 'March 25th, 2015'
    }
    {
      title: 'Automatic code deployment with Github Webhooks and saltStack'
      body: require('./posts/webhooks.html')
      blurb: """
      <pre>
        <code class="language-bash">
      Pushing to my git repo\n
      triggers a webhook\n
      that runs salt\n
      to update this website
      </code>
      </pre><br>
      """
      date: 'March 15th, 2015'
    }
    {
      title: 'Deploying our Demo Rails application'
      body: require('./posts/application.html')
      blurb: """
      <pre>
        <code class="language-bash">
      A pinch of Ansible\n
      One dash of git\n
      Put it in the oven for 15 minutes\n
      And out comes Devops
      </code>
      </pre><br>
      """
      date: 'March 10th, 2015'
    }
    {
      title: 'Creating a cloud server with Javascript'
      body: require('./posts/newServerRacksjs.html')
      blurb: """
      <pre>
        <code class="language-bash">
      Javascript?\n
      As an Automation tool?\n
      You Crazy!
      </code>
      </pre><br>
      """
      date: 'March 4th, 2015'
    }
    {
      title: 'Demo Rails application'
      body: require('./posts/rails.html')
      blurb: """
      <pre>
        <code class="language-bash">
      I needed a rails application to test a deployment with.\n
      Here is how I did it.\n
      You can copy paste these commands!
      </code>
      </pre><br>
      """
      date: 'February 25th, 2015'
    }
    {
      title: 'Hello and Welcome'
      body: require('./posts/welcome.html')
      blurb: """
      <pre>
        <code class="language-bash">
      Let me tell yout a litte bit about me,\n
      This site and the technology it uses,\n
      And why you should be reading it.
      </code>
      </pre><br>
      """
      date: 'January 23th, 2015'
    }
  ]
]
