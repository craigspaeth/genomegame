class window.Artwork extends Backbone.Model
  
  urlRoot: '/api/artworks'
  
  imageUrl: (size = 'medium') ->
    base = "http://static.artsy.net/additional_images/#{@get 'default_image_id'}"
    base += "/#{@get('additional_images')[0].image_version}" if @get('additional_images')[0].image_version > 0
    base += "/#{size}.jpg"