$ ->
  Backbone.history.start pushState: true
  autocomplete = new AutocompleteView
    el: $('input')
    url: '/api/match/cards'
  autocomplete.renderLi = (item) -> JST['cards/list_item'] item: item