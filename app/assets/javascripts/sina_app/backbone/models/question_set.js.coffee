class Dazuoxiaoti.Models.QuestionSet extends Backbone.Model
  choose: ->
    $.get('/sina_app/question_sets/' + @get('id'), ->
      $('#question').trigger('render')
    )

class Dazuoxiaoti.Collections.QuestionSets extends Backbone.Collection
  model: Dazuoxiaoti.Models.QuestionSet
  url: "/sina_app/question_sets"
