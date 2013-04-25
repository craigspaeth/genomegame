class window.User extends Backbone.Model
  
  url: '/api/users'
  
  initialize: ->
    console.log 'init'