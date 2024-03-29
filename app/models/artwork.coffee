Base = require './base'
_ = require 'underscore'

module.exports = class Artwork extends Base
  
  collectionName: 'artworks'
  
  geneNames: ->
    _.keys(@get('genome')?.genes ? [])
  
  @randomArtwork: (callback) ->
    params =
      title: { $exists: true }
      artist_id: { $exists: true }
      "genome.genes": { $ne: {}, $exists: true }
      "additional_images": { $size: 1 }
      "additional_images.0.image_versions": 'medium'
    @find(params).count (err, count) =>
      return callback err if err
      @find(params).limit(1).skip(_.random 0, count).toArray (err, docs) =>
        return callback err if err
        callback null, new @ docs[0]