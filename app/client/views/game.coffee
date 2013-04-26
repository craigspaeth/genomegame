class window.GameView extends Backbone.View
  
  el: '#game'
  
  kittenSnd: new Audio '/sounds/meow.wav'
  bombSnd: new Audio '/sounds/bomb.wav'
  gunSnd: new Audio '/sounds/gunshot.wav'
  
  initialize: ->
    @user = currentUser
    @users = new Users
    @artwork = new Artwork
    @artwork.url = '/api/current-artwork'
    @artwork.on 'change', @renderRandomArtwork
    socket.on 'user:enter', @fetchUsersAndRender
    socket.on 'user:enter',  => @kittenSnd.play()
    socket.on 'user:win', @fetchUsersAndRender
    socket.on 'user:win', @renderBetween
    socket.on 'user:win', => @bombSnd.play()
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
    @$('h1 span.names').html _.toSentence (@users.get(id).get('name') for id in ids)
    @$('.betweem-frame .artwork-container img').attr 'src', @artwork.imageUrl()
    @$('.betweem-frame ul.actual-genes').html (for gene in @artwork.matchedGenes(@randomGenes)
      "<li>#{gene}</li>"
    )
  
  renderRandomArtwork: =>
    @randomGenes = @artwork.randomGenes()
    @$('.artwork-title').html @artwork.get('title')
    @$('.artwork-frame img').attr 'src', @artwork.imageUrl()
    @$('ul.genes').html (for gene in @randomGenes
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
    @gunSnd.play()
  