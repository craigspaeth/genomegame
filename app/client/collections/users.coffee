class window.Users extends Backbone.Collection
  
  url: '/api/users'
  
  comparator: (user) -> -user.get('points')