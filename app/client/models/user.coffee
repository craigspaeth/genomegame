class window.User extends Backbone.Model
  
  urlRoot: '/api/users'
  
  defaults:
    selectedGenes: []
    points: 0