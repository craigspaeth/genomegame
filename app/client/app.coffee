$ ->
  window.currentUser = new User id: USER_ID
  window.socket = io.connect('http://localhost')
  currentUser.fetch().then ->
    console.log "Welcome #{currentUser.get 'name'}"
    window.router = new Router
    Backbone.history.start pushState: true