class window.GameView extends Backbone.View
  
  el: '#game'
  
  initialize: ->
    socket.on 'user:enter', @fetchUsersAndRender
    
  fetchUsersAndRender: =>
    (@users = new Users).fetch().then @renderUsers
  
  renderUsers: =>
    @$('ul.users').html @users.map (user) => """
      #{user.get 'name'}
    """
  
  events:
    'activate': 'activate'
  
  activate: ->