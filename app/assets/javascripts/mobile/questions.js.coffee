# All this logic will automatically be available in application.js.  # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/ 
  $.submit_answer = (value, index) ->
    $('#answer').val(value)
    $('#index').val(index)
    $('.question_form').submit()

  $.submit_category = (id, wanted) ->
    $('#id').val(id)
    $('#wanted').val(wanted)
    $('.category_form').submit()