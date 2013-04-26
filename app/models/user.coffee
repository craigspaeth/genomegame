Base = require './base'
_ = require 'underscore'

module.exports = class User extends Base
  
  collectionName: 'users'
  
  @findWinners: (currentArtwork, callback) ->
    return callback() unless currentArtwork?
    artworkGenes = currentArtwork.geneNames()
    User.find().toArray (err, docs) ->
      return callback(err) if err
      return callback() unless docs.length
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
      callback null, winners