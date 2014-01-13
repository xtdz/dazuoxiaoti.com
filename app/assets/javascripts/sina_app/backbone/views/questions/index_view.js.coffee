Dazuoxiaoti.Views.Questions ||= {}

class Dazuoxiaoti.Views.Questions.IndexView extends Backbone.View
  template: JST["sina_app/backbone/templates/questions/index"]

  events:
    "click #tiji": "show_question_sets"
    "click #dati": "show_question"
    "render #question": "show_question"

  initialize: ->
    @question_view = new Dazuoxiaoti.Views.Questions.ShowView()
    @project_view = new Dazuoxiaoti.Views.Projects.ShowView()
    @progress_view = new Dazuoxiaoti.Views.Projects.ProgressView()
    this

  render: ->
    $(@el).html(@template(question: @question))
    $(@el).find("#question").html(@question_view.render().el)
    $(@el).find("#question_sets").addClass('hidden')
    $(@el).find("#project").html(@project_view.render().el)
    $(@el).find("#progress").html(@progress_view.render().el)
    @_activate_fancy_links()
    this

  show_question_sets: ->
    @question_sets_view = new Dazuoxiaoti.Views.QuestionSets.IndexView()
    $(@el).find("#question_sets").html(@question_sets_view.render().el)
    $(@el).find("#question").addClass('hidden')
    $(@el).find("#dati").removeClass('hidden')
    $(@el).find("#tiji").addClass('hidden')
    $(@el).find("#question_sets").removeClass('hidden')

  show_question: ->
    @question_view = new Dazuoxiaoti.Views.Questions.ShowView()
    $(@el).find("#question").html(@question_view.render().el)
    $(@el).find("#question_sets").addClass('hidden')
    $(@el).find("#tiji").removeClass('hidden')
    $(@el).find("#dati").addClass('hidden')
    $(@el).find("#question").removeClass('hidden')


  ###################################
  ##                               ##
  ##        Helper Functions       ##
  ##                               ##
  ###################################

  _activate_fancy_links: ->
    _.each($(@el).find('a.fancy'), _bind_fancy_box)

  _paramLink = (link, param) ->
    arr = link.split("?")
    link = arr[0]
    if arr[1] == undefined
      return link + "?" + param
    else
      return link + "?" + arr[1] + "&" + param

  _bind_fancy_box= (element, index, list) ->
    href = _paramLink(element.name, "modal=true")
    $(element).fancybox({
      'type' : 'ajax',
      'href' : href,
    })


