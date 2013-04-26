class window.GameView extends Backbone.View
  
  el: '#game'
  
  initialize: ->
    @artwork = new Artwork
    @artwork.on 'change', @renderRandomArtwork
    socket.on 'user:enter', @fetchUsersAndRender
    socket.on 'artwork:random', (data) => @artwork.set data
    
  fetchUsersAndRender: =>
    (@users = new Users).fetch().then @renderUsers
  
  renderUsers: =>
    @$('ul.users').html @users.map (user) => """
      #{user.get 'name'}
    """
  
  renderRandomArtwork: =>
    @$('.artwork-title').html @artwork.get('title')
    @$('.artwork-frame img').attr 'src', @artwork.imageUrl()
    
  
  events:
    'activate': 'activate'
  
  activate: ->