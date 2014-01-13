#= require ./assets
#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Dazuoxiaoti =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  session: {}
  init: ->
    this.session.project = new Dazuoxiaoti.Models.Project()
    new Dazuoxiaoti.Routers.Main()
    new Dazuoxiaoti.Routers.Questions()
    Backbone.history.start()

$(document).ready ->
  Dazuoxiaoti.init()
