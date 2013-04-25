$ ->
  window.currentUser = new User id: USER_ID
  window.router = new Router
  Backbone.history.start pushState: true