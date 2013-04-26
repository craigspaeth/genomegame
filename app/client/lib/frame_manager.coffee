#
# Mixin to a router to wrap `route` so that it clears ajax requests and transitions frames.
#

Backbone.FrameManager =

  #
  # Declare regex: frame pairs. If the route matches the regex it will create an instance
  # of the frame once, and activate/deactivate that view from there on.
  #
  # A "frame" is a high-level view associated with an element that is a child of the #frames div.
  # A frame is often instantiated once and hangs around the duration of the session, which may
  # require some setup/teardown of events. In this case it may be helpful to listen for a change in
  # state (the "activate/deactivate" event triggered on the frame's element) or check the current
  # state (the frame element's "active" class).
  #
  frames: {}

  route: (route, name, callback) ->
    Backbone.Router::route.call @, route, name, =>
      @before route
      (callback or @[name])? arguments...

  before: (route) ->
    @deactivateCurrentFrame()
    @setCurrentFrame route
    @activateCurrentFrame()
    
  hideFrameUntilAjaxStop: ->
    return unless @currentFrame?
    @currentFrame.$el.css(opacity: 0)
    _.defer =>
      if _.isEmpty $.xhrMap
        @currentFrame.$el.css(opacity: 1)
      else
        @currentFrame.$el.one 'ajaxStop', => @currentFrame.$el.css(opacity: 1)
    
  activateCurrentFrame: ->
    @currentFrame.$el.trigger('activate').addClass('active') if @currentFrame?

  deactivateCurrentFrame: ->
    @currentFrame.$el.trigger('deactivate').removeClass('active') if @currentFrame?

  setCurrentFrame: (route) ->
    @_cachedFrames ?= {}
    @currentFrame = null
    for regex, klass of @frames
      if route.match new RegExp regex
        @currentFrame = @_cachedFrames[regex] ?= new klass()
        break
