class Mobile::QuestionSetsController < ApplicationController
  layout 'mobile/mobile'
  before_filter :authenticate_user!,:except=>[:index]
  before_filter :redirect_mobile_admin
  before_filter :require_admin, :except => [:index, :subscribe, :unsubscribe],

  def subscribe
    if params[:id] && (question_set = QuestionSet.where(:id=>params[:id]).first)
      current_user.question_sets.delete question_set
      current_user.question_sets << question_set
      # session_manager.notices << t('question_set.subscribe') + question_set.name
    end

    respond_to do |format|
      format.html { redirect_to question_sets_path }
      format.js { }
    end
  end

  def unsubscribe
    if params[:id] && (question_set = QuestionSet.where(:id=>params[:id]).first)
      current_user.question_sets.delete question_set
      # session_manager.notices << t('question_set.unsubscribe') + question_set.name
    end
    respond_to do |format|
      format.html { redirect_to question_sets_path }
      format.js { }
    end
  end

  def index
    @user_question_sets = current_user ? current_user.recent_sets : []
    ids = @user_question_sets.map {|question_set| question_set.id}
    if ids.empty?
      @featured_question_sets = QuestionSet.order('id DESC')
    else
      @featured_question_sets = QuestionSet.order('id DESC').where(['id NOT IN (?)', ids]).all.shuffle
    end
    @notices = session_manager.notices
  end

  def new
    @question_set = QuestionSet.new
  end

  def create
    @question_set = QuestionSet.new(params[:question_set])
    if @question_set.save
      respond_to do |format|
        format.html { redirect_to  }
      end
    end
  end

  def edit
    @question_set = QuestionSet.find(params[:id])
  end

  def update
    @question_set = QuestionSet.find(params[:id])
    respond_to do |format|
      if @question_set.update_attributes(params[:question_set])
        format.html  { redirect_to(edit_question_set_path(@question_set),:notice => 'Question set was successfully updated.') }
      end
    end
  end
end
