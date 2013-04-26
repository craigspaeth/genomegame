class window.GameView extends Backbone.View
  
  el: '#game'
      
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
    @$('.progress-bar').stop().css(width: '100%').animate { width: '0%' }, TIMEOUT
  
  submitSelection: ->
    currentUser.save()
    
  events:
    'click ul.genes li': 'selectGene'
    'activate': 'activate'
    
  activate: ->
    @artwork = new Artwork
    @artwork.on 'change', @renderRandomArtwork
    socket.on 'user:enter', _.debounce @fetchUsersAndRender
    socket.on 'artwork:random', (data) => 
      @artwork.set data
      setTimeout @submitSelection, TIMEOUT
  
  selectGene: (e) ->
    currentUser.get('selectedGenes').push $(e.currentTarget).find('.gene-name').html()
    