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
    
    $('#project_list .random_question_link').live('click', ()->
      $.get(formatLink(this.href, "js"))
      $(this).closest('.projects_list').find('.project_status').hide()
      $(this).parent().parent().children('.project_status').show()
      return false
    )

    $('#project_detail .random_question_link').live('click', ()->
      $.get(formatLink(this.href, "js"), ()->
        $('#project_panel').panel("close")
        setTimeout(()->
          $.hide_project_info()
        , 500)
      )
      $(this).closest('#project_panel').find('.project_status').hide()
      project_id = $(this).attr('data-pid')
      $(this).closest('#project_panel').find('#project_block_' + project_id + ' .project_status').show()
      return false
    )

    $('.project_info_link').live('click', ()->
      $.get(formatLink(this.href, "js"))
      return false
    )

    $.show_project_info = () ->
      $('#project_list').hide(300)
      $('#project_detail').show(300)

    $.hide_project_info = () ->
      $('#project_detail').hide(300)
      $('#project_list').show(300)

    $(".question-set-item").unbind('tap')
    $(".question-set-item").tap( ()->
      selector = $(this).closest('.category').find('.select_count')
      check = $(this).find('.button-check')
      cnt = parseInt($(selector).html())
      if (!$(check).is(":hidden"))
        $.get('/mobile/question_sets/' + $(this).attr('data-qsid') + '/unsubscribe.js')
        $(check).hide()
        $(selector).html(cnt - 1)
      else
        $.get('/mobile/question_sets/' + $(this).attr('data-qsid') + '/subscribe.js')
        $(check).show()
        $("#no_question_notice").hide()
        $(selector).html(cnt + 1)
    )
  )
)
