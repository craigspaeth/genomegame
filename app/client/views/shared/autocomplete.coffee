class window.AutocompleteView extends Backbone.View
  
  defaults:
    field: 'name'
    delay: 300
    
  initialize: ->
    @options = _.extend @defaults, @options
    @search = _.debounce @search, @options.delay
    @$results = @$el.after("<div class='ac_results'></div>").next('.ac_results')

  renderLi: (item) ->
    "<li>#{item[@options.field]}</li>"
  
  renderResults: (arr) ->
    "<ul>#{(@renderLi(item) for item in arr).join('')}</ul>"
  
  search: =>
    $.ajax(
      url: @options.url
      data: term: @$el.val()
    ).then (@res) =>
      @$results.html @renderResults @res
      @$results.find('li').click @select
    
  over: (dir) ->
    $over = @$results.find('.ac_over')
    $over.parent().children().removeClass('ac_over')
    $next = $over[dir]()
    unless $next.length
      @$results.find('li:first').addClass('ac_over') if dir is 'next'
      @$results.find('li:last').addClass('ac_over') if dir is 'prev'
      return
    $next.addClass('ac_over')
  
  select: (e) =>
    index = $(e.target).index()
    @trigger 'select', @res[index]
  
  events:
    'keyup': 'onKeyUp'
    
  onKeyUp: (e) =>
    { up, down, enter } = up: 38, down: 40, enter: 13
    switch e.which
      when up then @over 'prev'
      when down then @over 'next'
      when enter then @select target: @$results.find('.ac_over')
      else @search()