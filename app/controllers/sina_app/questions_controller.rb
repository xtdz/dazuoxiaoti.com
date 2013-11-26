class SinaApp::QuestionsController < SinaApp::ApplicationController
  before_filter :authenticate_user!, :assign_project
  respond_to :json

  def random
    count_down = session_manager.count_down
    if count_down == 0 and rand() < 0.3
      @question = current_user.get_next_sponsor_question(current_project.sponsor_id) || current_user.get_next_question(params[:question_set])
    else
      @question = current_user.get_next_question(params[:question_set])
    end

    if current_user.answer_quota <= 0
      json_hash = {
        id: -2
      }
    elsif @question.nil?
      json_hash = {
        id: -1
      }
    else
      json_hash = {
        id: @question.id,
        token: @question.token,
        title: @question.title,
        choices: @question.choices.shuffle,
        correct_answer: @question.correct_answer,
        explanation: @question.explanation
      }
    end

    respond_with json_hash
  end
end
