class SinaApp::AnswersController < SinaApp::ApplicationController
  before_filter :authenticate_user!, :assign_project
  respond_to :json

  def create
    @answer = Answer.new(params[:answer])
    @question = @answer.question
    @answer.correct = @question.correct_answer == @answer.choice
    current_user.add_answer_for_project @answer, @project, session_manager.referer

    redirect_to :controller => 'projects', :action => 'current'
  end
end
