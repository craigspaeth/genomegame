Base = require './base'
_ = require 'underscore'

module.exports = class Artwork extends Base
  
  collectionName: 'artworks'
  
  @randomArtwork: (callback) ->
    @count (err, count) =>
      return callback err if err
      @find(
        "genome.genes": { $ne: {}, $ne: null }
        "additional_images": { $size: 1 }
        "additional_images.0.image_versions": 'medium'
      ).limit(1).skip(_.random 0, count).toArray (err, docs) =>
        return callback err if err
        callback null, new @ docs[0]