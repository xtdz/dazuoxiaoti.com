class Dazuoxiaoti.Routers.Questions extends Backbone.Router
  routes:
    'questions': 'index'

  index: ->
    $("#intro").addClass("hidden")
    $("#container").removeClass("hidden")
    view = new Dazuoxiaoti.Views.Questions.IndexView()
    $("#container").html(view.render().el)
