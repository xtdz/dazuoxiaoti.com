Dazuoxiaoti.Views.Main ||= {}

class Dazuoxiaoti.Views.Main.IndexView extends Backbone.View
  template: JST["sina_app/backbone/templates/main/index"]

  initialize: (html) ->
    $(@el).html(html)

  render: =>
    $(@el).html(@template())
    return this
