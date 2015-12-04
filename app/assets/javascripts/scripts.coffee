ready = ->

  $('.carousel').carousel
    interval: 6000

  ### affix the navbar after scroll below header ###
  $('#nav').affix offset: top: $('header').height() - $('#nav').height()

  ### highlight the top nav as scrolling occurs ###
  $('body').scrollspy target: '#nav'

  ### smooth scrolling for scroll to top ###
  $('.scroll-top').click ->
    $('body,html').animate { scrollTop: 0 }, 1000

  ### smooth scrolling for nav sections ###
  $('#nav .navbar-nav li>a').click ->
    link = $(this).attr('href')
    posi = $(link).offset().top
    $('body,html').animate { scrollTop: posi }, 700

  ### copy loaded thumbnails into carousel ###
  $('.panel .img-responsive').on('load', ->
  ).each (i) ->
    if @complete
      item = $('<div class="item"></div>')
      itemDiv = $(this).parent('a')
      title = $(this).parent('a').attr('title')
      item.attr 'title', title
      $(itemDiv.html()).appendTo item
      item.appendTo '#modalCarousel .carousel-inner'
      if i == 0
        # set first item active
        item.addClass 'active'

  ### activate the carousel ###
  $('#modalCarousel').carousel interval: false

  ### change modal title when slide changes ###
  $('#modalCarousel').on 'slid.bs.carousel', ->
    $('.modal-title').html $(this).find('.active').attr('title')

  ### when clicking a thumbnail ###
  $('.panel-thumbnail>a').click (e) ->
    e.preventDefault()
    idx = $(this).parents('.panel').parent().index()
    id = parseInt(idx)
    $('#myModal').modal 'show'
    # show the modal
    $('#modalCarousel').carousel id
    # slide carousel to selected
    false


$(document).ready(ready)
$(document).on('page:load', ready)

