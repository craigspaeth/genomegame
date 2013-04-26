socketio = require 'socket.io'
Artwork = require './app/models/artwork'
_ = require 'underscore'
User = require './app/models/user'

module.exports = (server) ->
  
  io = socketio.listen(server, log: off)

  # Emit whenever a user logs in
  io.on 'connection', (socket) ->
    socket.on 'user:enter', (id) ->
      console.log "User #{id} entered"
      io.sockets.emit 'user:enter', id
  
  # Check who is the winner

  
  # Updates the winner's points
  rewardWinners = (users, callback = ->) ->
    return callback() unless users.length
    callback _.after users.length, callback
    user.set(points: user.get('points') + 1).save(callback) for user in users
    io.sockets.emit 'user:win', (user.id for user in users)
      
  # Select and emit a new artwork, and clear our the users selections
  emitRandomArtwork = (callback) ->
    Artwork.randomArtwork (err, artwork) ->
      return callback(err) if err
      Artwork.currentArtwork = artwork
      io.sockets.emit 'artwork:random', artwork.toJSON()
      callback()
  
  # Setup artwork loop
  setupRound = ->
    User.findWinners Artwork.currentArtwork, (err, winners) ->
      throw err if err
      rewardWinners winners if winners?.length
      emitRandomArtwork (err) ->
        throw err if err
        setTimeout setupRound, require('./config').TIMEOUT
  setupRound()