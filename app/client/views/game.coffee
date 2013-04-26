class window.GameView extends Backbone.View
  
  el: '#game'
  
  initialize: ->
    @user = currentUser
    @artwork = new Artwork
    @artwork.url = '/api/current-artwork'
    @artwork.on 'change', @renderRandomArtwork
    socket.on 'user:enter', _.debounce @fetchUsersAndRender
    socket.on 'artwork:random', (data) => 
      @artwork.set data
      @user.set selectedGenes: []
    socket.on 'user:win', (id) =>
      console.log 'WINNDER', id
      if @user.get('id') is id
        $('body').animate { opacity: 0 }, 'fast', ->
          $(@).animate { opacity: 1 }, 'fast'
    @artwork.fetch()
      
  fetchUsersAndRender: =>
    (@users = new Users).fetch().then @renderUsers
  
  renderUsers: =>
    @$('ul.users').html @users.map((user) =>
      JST['users/list_item'] user: user, current: user.get('id') is @user.get('id')
    ).join ''
  
  renderRandomArtwork: =>
    @$('.artwork-title').html @artwork.get('title')
    @$('.artwork-frame img').attr 'src', @artwork.imageUrl()
    @$('ul.genes').html (for gene in @artwork.randomGenes()
      JST['artworks/gene_list_item'] gene: gene
    )
    @$('.progress-bar').stop().css(width: '100%').animate { width: '0%' }, TIMEOUT
    
  events:
    'click ul.genes li': 'selectGene'
  
  selectGene: (e) ->
    @user.get('selectedGenes').push $(e.currentTarget).find('.gene-name').html()
    @user.save()
    $(e.currentTarget).css opacity: 0.3
  