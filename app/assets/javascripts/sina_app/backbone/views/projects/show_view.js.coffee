Dazuoxiaoti.Views.Projects ||= {}

class Dazuoxiaoti.Views.Projects.ShowView extends Backbone.View
  template: JST["sina_app/backbone/templates/projects/show"]

  initialize: ->
    @project = Dazuoxiaoti.session.project
    @project.fetch()
    @project.on('change', @render, this)

  render: ->
    $(@el).html(@template(project: @project))
    this
