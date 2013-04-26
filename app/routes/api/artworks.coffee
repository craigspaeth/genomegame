Artwork = require "#{process.cwd()}/app/models/artwork"
_ = require 'underscore'

@['GET artworks/:id'] = (req, res) ->
  artwork = new Artwork _id: req.params.id
  artwork.fetch (err, doc) ->
    return res.send 500, err if err
    res.send artwork.toJSON()
    
@['GET artworks'] = (req, res) ->
  Artwork.find().limit(10).toArray (err, docs) ->
    return res.send 500, err if err
    res.send Artwork.docsToJSON(docs)

@['POST artworks'] = (req, res) ->
  artwork = new Artwork req.body
  artwork.save (err, docs) ->
    req.session.artworkId = artwork.set(docs[0]).toJSON().id
    return res.send 500, err if err
    res.send artwork.toJSON()
    
@['DELETE artworks/:id'] = (req, res) ->
  artwork = new Artwork _id: req.params.id
  artwork.fetch (err, doc) ->
    return res.send 500, err if err
    artwork.destroy (err) ->
      return res.send 500, err if err
      res.send artwork.toJSON()
      
@['GET random-artwork'] = (req, res) ->
  Artwork.randomArtwork (err, artwork) ->
    res.send artwork.toJSON()