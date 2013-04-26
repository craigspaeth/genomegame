class window.GameView extends Backbone.View
  
  el: '#game'
  
  initialize: ->
    @artwork = new Artwork
    @artwork.url = '/api/random-artwork'
    @artwork.on 'change', @renderRandomArtwork
    socket.on 'user:enter', @fetchUsersAndRender
    socket.on 'artwork:random', (data) => @artwork.set data
    @artwork.fetch()
    
  fetchUsersAndRender: =>
    (@users = new Users).fetch().then @renderUsers
  
  renderUsers: =>
    @$('ul.users').html @users.map((user) =>
      JST['users/list_item'] user: user
    ).join ''
  
  renderRandomArtwork: =>
    @$('.artwork-title').html @artwork.get('title')
    @$('.artwork-frame img').attr 'src', @artwork.imageUrl()
    @$('ul.genes').html (for gene in @artwork.randomGenes()
      JST['artworks/gene_list_item'] gene: gene
    )
  
  events:
    'activate': 'activate'
  
  activate: ->