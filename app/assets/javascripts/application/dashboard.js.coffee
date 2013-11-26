# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->
  timer = 0
  $('div.user_controls').mouseenter( ->
    timer = setTimeout( ->
      $('div.user_controls').addClass('hover')
      $('div.control_links').slideDown('200')
    , 500)
  ).mouseleave( ->
    clearTimeout(timer)
    $('div.control_links').slideUp('200')
    setTimeout( ->
      $('div.user_controls').removeClass('hover')
    , 400)
  )

  $('input.log_out').bind('mouseenter mouseleave', ->
    $(this).toggleClass('hover')
  )
