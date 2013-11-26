jQuery ($) ->
  
  $('div.supplies div').mouseenter( ->
    $(this).addClass('hovered')
    $($(this).attr('name')).show()
  ).mouseleave( ->
    $(this).removeClass('hovered')
    $($(this).attr('name')).hide()
  )

