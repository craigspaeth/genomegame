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