class window.GameView extends Backbone.View
  
  el: '#game'
  
  initialize: ->
    @user = currentUser
    @users = new Users
    @artwork = new Artwork
    @artwork.url = '/api/current-artwork'
    @artwork.on 'change', @renderRandomArtwork
    socket.on 'user:enter', @fetchUsersAndRender
    socket.on 'user:win', @fetchUsersAndRender
    socket.on 'user:win', @renderBetween
    socket.on 'artwork:random', (data) => 
      @artwork.set data
      @user.save selectedGenes: []
    @artwork.fetch()
    @fetchUsersAndRender()
      
  fetchUsersAndRender: =>
    @users.fetch().then =>
      @renderUsers()
  
  renderUsers: =>
    @$('ul.users').html @users.map((user) =>
      JST['users/list_item'] user: user, current: user.get('id') is @user.get('id')
    ).join ''
  
  renderBetween: (ids) =>
    @$('.betweem-frame').show()
    @$('.artwork-frame').hide()
    @$('h1 span.names').html (@users.get(id).get('name') for id in ids).join(' ')
  
  renderRandomArtwork: =>
    @$('.artwork-title').html @artwork.get('title')
    @$('.artwork-frame img').attr 'src', @artwork.imageUrl()
    @$('ul.genes').html (for gene in @artwork.randomGenes()
      JST['artworks/gene_list_item'] gene: gene
    )
    @$('.progress-bar').stop().css(width: '100%').animate { width: '0%' }, TIMEOUT
    @$('.betweem-frame').hide()
    @$('.artwork-frame').show()
    
  events:
    'click ul.genes li': 'selectGene'
  
  selectGene: (e) ->
    @user.get('selectedGenes').push $(e.currentTarget).find('.gene-name').html()
    @user.save()
    $(e.currentTarget).addClass 'active'
  