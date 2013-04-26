class window.User extends Backbone.Model
  
  urlRoot: '/api/users'
  
  defaults:
    selectedGenes: []
    
  parse: (res) ->
    res.selectedGenes = []
    res