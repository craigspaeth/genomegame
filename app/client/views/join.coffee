class window.JoinView extends Backbone.View
  
  el: '#join'
  
  events:
    'activate': 'activate'
    'submit form': 'createUser'
  
  activate: ->
    _.defer => @$('input').focus()  
  
  createUser: ->
    new User(name: @$('input').val()).save().then ->
      return
      router.navigate '/game', trigger: true
    false