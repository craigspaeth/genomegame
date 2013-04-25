$ ->
  window.currentUser = new User id: USER_ID
  currentUser.fetch().then ->
    alert "Welcome #{currentUser.get 'name'}"
    window.router = new Router
    Backbone.history.start pushState: true