# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->
  $('input.unsubscribe').attr('checked', true)
  $('input.subscribe').attr('checked', false)

  on_subscribe = (context) ->
    $.get('/question_sets/' + context.value + '/subscribe')
    $(context).removeClass('subscribe')
    $(context).addClass('unsubscribe')
    $(context).attr('checked', true)
    question_set = $(context).parent().parent()
    question_set.children('.question_set_wrap').removeClass('question_set_hovered')
    question_set.remove()
    $('.question_sets_right .question_set_table').prepend(question_set)
    $(context).on('change', ->
      on_unsubscribe(this)
    )

  on_unsubscribe = (context)->
    $.get('/question_sets/' + context.value + '/unsubscribe')
    $(context).removeClass('unsubscribe')
    $(context).addClass('subscribe')
    $(context).attr('checked', false)
    question_set = $(context).parent().parent()
    question_set.children('.question_set_wrap').removeClass('question_set_hovered')
    question_set.remove()
    $('.question_sets_left .question_set_table').prepend(question_set)
    $(context).on('change', ->
      on_subscribe(this)
    )

  $('input.unsubscribe').on('change', ->
    on_unsubscribe(this)
  )

  $('input.subscribe').on('change', ->
    on_subscribe(this)
  )

###
  $('.question_set_narrow').live('mouseenter', ->
    $(this).children('.question_set_wrap').addClass('question_set_hovered')
  )

  $('.question_set_narrow').live('mouseleave', ->
    $(this).children('.question_set_wrap').removeClass('question_set_hovered')
  )
###

