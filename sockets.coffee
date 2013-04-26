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
  rewardWinner = (callback) ->
    return callback() unless Artwork.currentArtwork?
    artworkGenes = Artwork.currentArtwork.geneNames()
    User.find().toArray (err, docs) ->
      return callback(err) if err
      users = (new User(doc) for doc in docs)
      sorted = _.sortBy(users, (user) ->
        numRight = _.intersection(user.get('selectedGenes'), artworkGenes).length
        numWrong = user.get('selectedGenes').length - numRight
        score = numRight - numWrong
        user.set score: score
        -score
      )
      topScore = sorted[0].get('score')
      winners = (user for user in users when user.get('score') is topScore)
      console.log "#{(user.get('name') for user in winners)} won!"
      io.sockets.emit 'user:win', (winner.get('id') for winner in winners)
      callback()
    
  # Select and emit a new artwork, and clear our the users selections
  emitRandomArtwork = (callback) ->
    Artwork.randomArtwork (err, artwork) ->
      return callback(err) if err
      Artwork.currentArtwork = artwork
      io.sockets.emit 'artwork:random', artwork.toJSON()
      callback()
  
  # Setup artwork loop
  setupRound = ->
    rewardWinner (err) ->
      throw err if err
      emitRandomArtwork (err) ->
        throw err if err
        setTimeout setupRound, require('./config').TIMEOUT
  setupRound()