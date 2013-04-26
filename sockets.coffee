socketio = require 'socket.io'
Artwork = require './app/models/artwork'

module.exports = (server) ->
  
  io = socketio.listen(server, log: off)

  # Emit whenever a user logs in
  io.on 'connection', (socket) ->
    socket.on 'user:enter', (id) ->
      io.sockets.emit 'user:enter', id

  # Every so many intervals emit a new artwork
  emitArtwork = ->
    Artwork.randomArtwork (err, artwork) ->
      io.sockets.emit 'artwork:random', artwork.toJSON()
  setInterval emitArtwork, 20000