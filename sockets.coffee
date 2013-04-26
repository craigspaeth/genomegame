socketio = require 'socket.io'
Artwork = require './app/models/artwork'
_ = require 'underscore'
User = require './app/models/user'

module.exports = (server) ->
  
  io = socketio.listen(server, log: off)

  # Emit whenever a user logs in
  io.on 'connection', (socket) ->
    socket.on 'user:enter', (id) ->
      io.sockets.emit 'user:enter', id
  
  # Check who is the winner
  rewardWinner = (callback) ->
    return callback() unless Artwork.currentArtwork?
    artworkGenes = Artwork.currentArtwork.geneNames()
    User.find().toArray (err, docs) ->
      return callback(err) if err
      console.log (for doc in docs
        user = new User(doc)
        {
          name: user.get('name')
          match: _.intersection(user.get('selectedGenes'), artworkGenes).length
          diff: _.difference(artworkGenes, user.get('selectedGenes')).length
          selected: user.get('selectedGenes').length
        }
      )
      callback()
    
  # Select and emit a new artwork, and clear our the users selections
  emitRandomArtwork = (callback) ->
    Artwork.randomArtwork (err, artwork) ->
      return callback(err) if err
      User.update {}, { selectedGenes: [] }, (err, docs) ->
        return callback(err) if err
        Artwork.currentArtwork = artwork
        console.log "Selected #{Artwork.currentArtwork.get 'title'} with "  +
                    " #{Artwork.currentArtwork.geneNames().length} genes."
        io.sockets.emit 'artwork:random', artwork.toJSON()
        callback()
  
  # Setup artwork loop
  setupRound = ->
    rewardWinner (err) ->
      throw err if err
      emitRandomArtwork (err) ->
        throw err if err
        setTimeout setupRound, TIMEOUT
  setupRound()
  
module.exports.TIMEOUT = TIMEOUT = 10000