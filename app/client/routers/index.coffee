class window.Router extends Backbone.Router
  
  _.extend @prototype, Backbone.FrameManager
  
  routes:
    'join': 'join'
    'game': 'game'
    
  frames:
    'game': GameView
    'join': JoinView
  
  initialize: ->
    _.defer => @navigate (if currentUser.isNew() then '/join' else '/game'), trigger: true
    
  game: ->
    @navigate '/join', trigger: true if currentUser.isNew()
    socket.emit 'user:enter', currentUser.id
    
  join: ->
    console.log 'MOO'