# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery(($) ->
  $(document).ready( ->

    formatLink = (link, format) ->
      arr = link.split("?")
      link = arr[0]
      params = arr[1] || ""
      return link + "." + format + "?" + params
    
    $('.random_project_link').live('click', ()->
      $.get(formatLink(this.href, "js"))
      setTimeout(()->
        $('#project_panel').panel("close")
      , 1000)
      $(this).closest('.projects_list').find('.project_status').hide()
      $(this).parent().parent().children('.project_status').show()
      return false
    )

    $('.random_project_link_d').live('click', ()->
      $.get(formatLink(this.href, "js"))
      $('#project_info_panel').panel("close")
      $(this).closest('#pageone').find('.projects_list .project_status').hide()
      project_id = $(this).attr('data-pid')
      $(this).closest('#pageone').find('#project_block_' + project_id + ' .project_status').show()
      return false
    )

    $('.project_info_link').live('click', ()->
      $.get(formatLink(this.href, "js"))
      return false
    )
  )
)
