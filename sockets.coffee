socketio = require 'socket.io'
Artwork = require './app/models/artwork'
_ = require 'underscore'

module.exports = (server) ->
  
  io = socketio.listen(server, log: off)

  # Emit whenever a user logs in
  io.on 'connection', (socket) ->
    socket.on 'user:enter', (id) ->
      io.sockets.emit 'user:enter', id
  
  # Check who is the winner
  rewardWinner = (callback) ->
    return callback() unless Artwork.currentArtwork?
    # User.find(selectedGenes: { $in: })
    console.log Artwork.currentArtwork.geneNames()
    callback()
    
  # Every so many intervals emit a new artwork
  emitRandomArtwork = ->
    Artwork.randomArtwork (err, artwork) ->
      io.sockets.emit 'artwork:random', artwork.toJSON()
      Artwork.currentArtwork = artwork
  
  setInterval (->
    rewardWinner ->
      emitRandomArtwork()
  ), TIMEOUT
  
module.exports.TIMEOUT = TIMEOUT = 5000