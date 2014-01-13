Dazuoxiaoti.Views.QuestionSets ||= {}

class Dazuoxiaoti.Views.QuestionSets.IndexView extends Backbone.View
  template: JST["sina_app/backbone/templates/question_sets/index"]

  initialize: ->
    @question_sets = new Dazuoxiaoti.Collections.QuestionSets()
    @question_sets.fetch()
    @question_sets.on('reset', @render, this)

  render: ->
    $(@el).html(@template(question_sets: @question_sets))
    @question_sets.each(@append_set, this)
    this

  append_set: (question_set) ->
    view = new Dazuoxiaoti.Views.QuestionSets.ShowView(question_set)
    $(@el).find('.question_sets').append(view.render().el)


