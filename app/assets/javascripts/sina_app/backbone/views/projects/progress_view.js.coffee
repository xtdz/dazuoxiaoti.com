Dazuoxiaoti.Views.Projects ||= {}

class Dazuoxiaoti.Views.Projects.ProgressView extends Backbone.View
  template: JST["sina_app/backbone/templates/projects/progress"]

  initialize: ->
    @project = Dazuoxiaoti.session.project
    @project.on('change', @render, this)

  render: ->
    $(@el).html(@template(project: @project))
    this

