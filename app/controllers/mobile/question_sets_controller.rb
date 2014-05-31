class Mobile::QuestionSetsController < ApplicationController
  layout 'mobile/mobile'
  before_filter :authenticate_user!,:except=>[:index]
  before_filter :redirect_mobile_admin

  def subscribe
    if params[:id] && (question_set = QuestionSet.where(:id=>params[:id]).first)
      current_user.question_sets.delete question_set
      current_user.question_sets << question_set
      # session_manager.notices << t('question_set.subscribe') + question_set.name
    end

    respond_to do |format|
      #format.html { redirect_to question_sets_path }
      format.js { render :js => ""}
    end
  end

  def unsubscribe
    if params[:id] && (question_set = QuestionSet.where(:id=>params[:id]).first)
      current_user.question_sets.delete question_set
      # session_manager.notices << t('question_set.unsubscribe') + question_set.name
    end
    respond_to do |format|
      #format.html { redirect_to question_sets_path }
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
