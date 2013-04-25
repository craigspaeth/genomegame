class window.JoinView extends Backbone.View
  
  el: '#join'
  
  initialize: ->
    @$('input').focus()
  
  events:
    'submit form': 'createUser'
    
  createUser: ->
    new User(name: @$('input').val()).save()
    false
    