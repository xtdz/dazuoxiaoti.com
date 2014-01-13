Dazuoxiaoti.Views.Questions ||= {}

class Dazuoxiaoti.Views.Questions.ShowView extends Backbone.View
  template: JST["sina_app/backbone/templates/questions/show"]

  events: {
    "click #choice_0": "submit_0",
    "click #choice_1": "submit_1",
    "click #choice_2": "submit_2",
    "click #choice_3": "submit_3",
    "click .skip" : "skip"
    "click .next" : "next"
    "click .cursor_next" : "next"
  }

  initialize: ->
    @question = new Dazuoxiaoti.Models.Question()
    @question.fetch()
    @question.on('change', @render, this)

  render: ->
    $(@el).html(@template(question: @question))
    this

  submit_0: ->
    @submit_answer(0)

  submit_1: ->
    @submit_answer(1)

  submit_2: ->
    @submit_answer(2)

  submit_3: ->
    @submit_answer(3)

  skip: ->
    @question.skip()

  next: ->
    @question.next()

  submit_answer: (index) ->
    @question.submit_answer(index)
