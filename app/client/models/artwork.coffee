class window.Artwork extends Backbone.Model
  
  urlRoot: '/api/artworks'
  
  imageUrl: (size = 'medium') ->
    base = "http://static.artsy.net/additional_images/#{@get 'default_image_id'}"
    base += "/#{@get('additional_images')[0].image_version}" if @get('additional_images')[0].image_version > 0
    base += "/#{size}.jpg"
  
  geneNames: ->
    (name for name, val of @get('genome').genes)
    
  randomGenes: ->
    _.shuffle(_.sample(@geneNames(), 4).concat(_.sample(allGenes, 4)))
    
  matchedGenes: (geneNames) ->
    _.intersection @geneNames(), geneNames