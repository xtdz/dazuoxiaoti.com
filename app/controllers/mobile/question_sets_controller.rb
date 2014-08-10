class Mobile::QuestionSetsController < ApplicationController
  before_filter :authenticate_user!,:except=>[:index]

  def subscribe
    if params[:id] && (question_set = QuestionSet.find(params[:id]))
      current_user.question_sets.delete question_set
      current_user.question_sets << question_set
      session[:current_question_set] = nil
    end

    respond_to do |format|
      format.js { render :js => ""}
    end
  end

  def unsubscribe
    if params[:id] && (question_set = QuestionSet.find(params[:id]))
      current_user.question_sets.delete question_set
      session[:current_question_set] = nil
    end
    respond_to do |format|
      format.js { render :js => ""}
    end
  end

  def index
    @notices = session_manager.notices
    respond_to do |format|
      format.js { render :js => "$('#question_set_panel').panel('open')"}
    end
  end

end
