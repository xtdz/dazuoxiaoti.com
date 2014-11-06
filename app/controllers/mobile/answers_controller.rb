class Mobile::AnswersController < ApplicationController
  before_filter :assign_project, :expire_project

  def create
  	session.delete(:current_question_id)
    session_manager.count_down
    @question = Question.find(params[:question_id])
    @answer = Answer.new(params[:answer])
    @answer.question = @question
    @answer.correct = @question.correct_answer == @answer.choice
    @selected_index = @question.choices.index(@answer.choice)
    if user_signed_in?
      current_user.add_answer_for_project @answer, current_project, session_manager.referer, true
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
    @question_set = @question.question_sets.first
    QuestionTrace.record_answer(@question,@selected_index,@answer.correct?)
    respond_to do |format|
      if @answer.correct?
        @answer.analy_answer_for_card if params["project_id"].to_i==14
        format.js {render :file => "mobile/answers/correct"}
      else
        format.js {render :file => "mobile/answers/wrong"}
      end
    end
  end

end
