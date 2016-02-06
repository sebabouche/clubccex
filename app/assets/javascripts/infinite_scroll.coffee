ready = ->

  # Setup plugin and define optional event callbacks
  $('.scrollable').infinitePages
   debug: true
   #buffer: 300 # load new page when within 200px of nav link
   # context: '.scrollable' # define the scrolling container (defaults to window)
   loading: ->
     # jQuery callback on the nav element
     $(this).text("Chargement...")
   success: ->
     # called after successful ajax call
   error: ->
     # called after failed ajax call
     $(this).text("Trouble! Please drink some coconut water and click again")

$(document).ready(ready)
$(document).on('page:load', ready)
