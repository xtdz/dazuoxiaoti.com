Dazuoxiaoti.Views.QuestionSets ||= {}

class Dazuoxiaoti.Views.QuestionSets.ShowView extends Backbone.View
  template: JST["sina_app/backbone/templates/question_sets/show"]

  events:
    "mouseenter .question_set_wrap": "hover"
    "mouseleave .question_set_wrap": "unhover"
    "click .question_set_wrap" : "choose"

  initialize: (question_set)->
    @question_set = question_set

  render: ->
    $(@el).html(@template(question_set: @question_set))
    this

  hover: (event) ->
    $(@el).find('.question_set_wrap').addClass("question_set_hovered")

  unhover: (question_set) ->
    $(@el).find('.question_set_wrap').removeClass("question_set_hovered")

  choose: ->
    @question_set.choose()

