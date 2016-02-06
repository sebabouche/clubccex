ready = ->

  $('.alert').fadeTo(6000, 500).slideUp 500, ->
    $('#success-alert').alert 'close'

$(document).ready(ready)
$(document).on('page:load', ready)
