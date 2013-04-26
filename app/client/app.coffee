$ ->
  window.currentUser = new User id: USER_ID
  window.socket = io.connect SERVER_URL
  currentUser.fetch().then ->
    console.log "Welcome #{currentUser.get 'name'}"
    window.router = new Router
    Backbone.history.start pushState: true