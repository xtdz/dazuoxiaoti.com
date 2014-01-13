# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$.change_selected = (clicked) ->
  clicked.siblings().removeClass()
  clicked.addClass("selected")
    
$.change_content = (showed) ->
  $('.'+showed).siblings().hide()
  $('.'+showed).show()
