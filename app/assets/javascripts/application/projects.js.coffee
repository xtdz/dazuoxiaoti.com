jQuery ($) ->
  $('div.proj_small a').bind('click', ->
    $('div.proj.displayed').removeClass('displayed').addClass('hidden')
    $(this.name).removeClass('hidden').addClass('displayed')
    $('div.proj_small.selected').removeClass('selected')
    $(this).parent().addClass('selected')
  )
    
  $('div.project_slide_icon a').bind('click', ->
    highlight_tab($(this))
    resetInterval()
    return false
  )

  highlight_tab = (link) ->
    $('div.projects_slides div.project_block_wrapped.displayed').removeClass('displayed').addClass('hidden')
    $(link.attr("name")).removeClass('hidden').addClass('displayed')
    $('div.project_slide_icon.selected').removeClass('selected')
    link.parent().addClass('selected')
  
  next_tab = ->
    tabs = $('div.project_slide_icon a.project_icon')
    onTab = tabs.parent().filter('.selected')
    if onTab.index() < tabs.length-1
      nextTab = onTab.next()
    else
      nextTab = tabs.parent().first()
    highlight_tab(nextTab.children().first())
  
  resetInterval = ->
    clearInterval($._interval)
    $._interval = setInterval( next_tab, 5000)
  
  resetInterval()
