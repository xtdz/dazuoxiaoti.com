class Dazuoxiaoti.Models.Question extends Backbone.Model
  url: ->
    return '/sina_app/questions/random'

  allowedToEdit: (acount) ->
    return false

  skip: ->
    params = {}
    params['answer'] = {
      'question_id': this.get('id')
      'state': 2
    }
    $.post('/sina_app/answers', params, this.update_stats, 'json')
    this.next()

  next: ->
    this.fetch()
    this.clear(silent: true)

  submit_answer: (index) ->
    choices = this.get('choices')
    if choices && index >= 0 && index <= 3
      params = {}
      params['answer'] = {
        'question_id': this.get('id')
        'choice': choices[index]
      }
      $.post('/sina_app/answers', params, this.update_stats, 'json')
      this.set('selected_answer', choices[index])

  update_stats: (data)->
    if Dazuoxiaoti.session.project
      Dazuoxiaoti.session.project.set(data)


