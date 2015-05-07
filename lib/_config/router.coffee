@subs = new SubsManager()

Router.configure
  layoutTemplate: "masterLayout"
  loadingTemplate: "loading"
  notFoundTemplate: "notFound"
  routeControllerNameConverter: "camelCase"

  onBeforeAction: ->
  	# Redirect to set username if required
    if Config.username and Meteor.userId() and not Meteor.user().username
      @redirect '/setUserName'
    @next()

Router.waitOn ->
  subs.subscribe 'user'

onAfterAction = ->
  if Meteor.isClient
    window.scrollTo(0,0)

Router.onAfterAction onAfterAction

#To allow non-logged in users to access more routes, add it in the config file
publicRoutes = _.union Config.publicRoutes || [], [
  'home'
  'atSignIn'
  'atSignUp'
  'atForgotPassword'
  'atSignOut'
]

Router.plugin 'ensureSignedIn', except: publicRoutes