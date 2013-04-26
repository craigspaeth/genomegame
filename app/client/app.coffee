$ ->
  window.currentUser = new User id: USER_ID
  window.socket = io.connect(SERVER_URL)
  currentUser.fetch().then ->
    console.log "Welcome #{currentUser.get 'name'}"
    Backbone.history.start pushState: true
    window.router = new Router