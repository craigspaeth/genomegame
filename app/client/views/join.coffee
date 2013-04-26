class window.JoinView extends Backbone.View
  
  el: '#join'
  
  events:
    'activate': 'activate'
    'submit form': 'createUser'
  
  activate: ->
    _.defer => @$('input').focus()  
  
  createUser: ->
    currentUser.save(name: @$('input').val()).then ->
      router.navigate '/game', trigger: true
    false