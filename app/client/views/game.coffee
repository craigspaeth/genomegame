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
    @$('ul.users').html @users.map((user) =>
      JST['users/list_item'] user: user
    ).join ''
  
  renderRandomArtwork: =>
    @$('.artwork-title').html @artwork.get('title')
    @$('.artwork-frame img').attr 'src', @artwork.imageUrl()
    console.log (name for name, val of @artwork.get('genome').genes)
    @$('ul.genes').html (for name, val of @artwork.get('genome').genes
      JST['artworks/gene_list_item'] gene: name
    )
  
  events:
    'activate': 'activate'
  
  activate: ->