require './vendor/angular.js'
require './vendor/prism.js'

app = angular.module 'erulabs', []

app.controller 'blogController', ['$scope', '$sce', ($scope, $sce) ->
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

  $scope.blog = [
    {
      title: 'Drupal 7 in 2015, or: How to make an old dog modern'
      body: require('./posts/Drupal-7-in-2015.html')
      blurb: """
      <p>
      PHP hasn't gone away, and there are still a huge number of sites out there making use of Wordpress, Drupal or custom PHP code. They're slow to respond, they often require Apache (massive .htaccess files anyone?), they have central points of failure (single MySQL master), they cache incredibly poorly (if at all), and they spend almost all their time serving static content off the disk (in the case of most blogs in 2015 - they're primarily serving photos.)
      </p><p>
      So what to do? How does the state of the Cloud in 2015 help solve these problems? Let's first look at some of the primary problems with a typical Drupal7 installation...
      """
      date: 'January 14th, 2015'
    }
    {
      title: 'PerfectStack: NodeJS Salt and the Cloud - Part 1: Static sites'
      body: require('./posts/Developing-and-deploying-static-sites-with-GulpJS-and-the-Cloud.html')
      blurb: """
      <p>
        In the beginning, there was HTML. And for a while, it was good. Then came CSS and JavaScript and for a while, that was good too. The static site was born and then died immediatly. It's killer - the backend - was armed to the teeth with power and possibility. First PERL and later PHP scripts regularly wrote out HTML and sometimes even JavaScript - as we layered technologies one on top of each other things started to get messy. Applications regularly tightly depended on specific application settings (Apache rewrite rules anyone?), or had bizarre dependences which for some reason only RedHat EL 4 satisfies. What began as a "Look what I can do!" quickly evolved into "Oh god what did I do?".
      </p><p>
         Is it even possible for a normal web developer to build a web application any more? Which frameworks to pick? Which clouds to use? Do we need a team of 10 experts and a corporate SLA? This article will come in a few parts, and we'll work up to the full web application and talk about all the pieces - but for now let's start by going back in time and creating a static site - A site like we would have made before we started renaming our .html files as .php because we wanted a page changer or some text entry field. Let's reject hacky tricks and reject billion line frameworks. <b>Let's build a modern website</b>.</p>
      """
      date: 'June 5th, 2014'
    }
  ]
]
