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

    $('#project_link').live('click', ()->
      $.get(formatLink(this.href, "js"))
      $('#mmypanel').panel("close")
      return false
    )
  )
)

