class AnswersController < ApplicationController
  before_filter :assign_project, :expire_project,:check_mobile

  def create
  	session.delete(:current_question_id)
  	session_manager.count_down
    @question = Question.find(params[:question_id])
    @answer = Answer.new(params[:answer])
    @answer.question = @question
    @answer.correct = @question.correct_answer == @answer.choice
    @selected_index = @question.choices.index(@answer.choice)
    if user_signed_in?
      current_user.add_answer_for_project @answer, current_project, session_manager.referer
    else
    #  binding.pry
      if session_manager.referer

        @participation = Participation.get_participation(session_manager.referer, @project)
        if @answer.correct?
          @participation.increment_contribution
        end
      end
      session_manager.add_answer @answer
    end
    @choices = @question.choices
    @linked_question = ""
    last_string = @question.title
    @question.keywords.each do |k|
      i = last_string.index(k.name)
      break if i.nil?
      @linked_question += last_string[0, i]
      @linked_question += " <a class = 'hudong' target='_blank' href = 'http://www.hudong.com/wiki/" + k.name + "?out=xiaotidazuo' onclick=\"_gaq.push(['_trackEvent', 'Outbound', 'Hudong', 'solution_partial']);\">[" + k.name + "]</a> "
      last_string = last_string[i+k.name.length, last_string.length]
    end
    @question_set = @question.question_sets.first
    @linked_question += last_string
    QuestionTrace.record_answer(@question,@selected_index,@answer.correct?)
    respond_to do |format|
      if @answer.correct?
        @answer.analy_answer_for_card if params["project_id"].to_i==14
        format.js {render :file => "answers/correct"}
      else
        format.js {render :file => "answers/wrong"}
      end
    end
  end

  def check_mobile
    if from_mobile? && mobile_admin?
      redirect_to '/mobile/home'
    end
  end

end
