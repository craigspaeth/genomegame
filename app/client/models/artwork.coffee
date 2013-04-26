class window.Artwork extends Backbone.Model
  
  urlRoot: '/api/artworks'
  
  imageUrl: (size = 'medium') ->
    base = "http://static.artsy.net/additional_images/#{@get 'default_image_id'}"
    base += "/#{@get('additional_images')[0].image_version}" if @get('additional_images')[0].image_version > 0
    base += "/#{size}.jpg"
    
  # Merge 5 random genes in this artwork with 5 random genes from the total 
  randomGenes: ->
    geneNames = (name for name, val of @get('genome').genes)
    _.shuffle(_.sample(geneNames, 10).concat(_.sample(allGenes, 10)))[0...8]