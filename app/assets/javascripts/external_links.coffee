ready = ->

  $("a").click ->
    link_host = this.href.split("/")[2]
    document_host = document.location.href.split("/")[2]

    if (link_host != document_host)
      window.open this.href
      return false

$(document).ready(ready)
$(document).on('page:load', ready)
