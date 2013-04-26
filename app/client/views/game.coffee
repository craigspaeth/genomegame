class window.GameView extends Backbone.View
  
  el: '#game'
  
  initialize: ->
    @artwork = new Artwork
    @artwork.url = '/api/random-artwork'
    @artwork.fetch().then @renderRandomArtwork
    socket.on 'user:enter', @fetchUsersAndRender
    
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