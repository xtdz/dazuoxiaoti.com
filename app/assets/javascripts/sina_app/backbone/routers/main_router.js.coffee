class Dazuoxiaoti.Routers.Main extends Backbone.Router
  routes:
    '': 'index'

  index: ->
    $("#intro").removeClass("hidden")
    $("#container").addClass("hidden")
