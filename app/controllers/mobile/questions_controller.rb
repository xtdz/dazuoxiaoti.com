class Mobile::QuestionsController < ApplicationController
  layout 'mobile/questions/question'
  before_filter :assign_project, :expire_project, :assign_other_projects
  def show
    session_manager.current_url = 'mobile/questions/random?project_id='+ @project.id.to_s
    @question = Question.find_by_token params[:id]

    if !@question.nil?
      @question_set = @question.question_sets.first
      render_question
    else
      redirect_to :action => :random
    end
  end

  def random
      # session_messenger.count_down decrements count_down everytime it's called
    count_down = session_manager.count_down
    question_set_params_string = params[:question_set].nil? ? '' : '&question_set='+params[:question_set]
    session_manager.current_url = 'mobile/questions/random?project_id='+ @project.id.to_s + question_set_params_string
  
    @question = nil
    if session[:current_question_id] && params[:question_set].nil? && params[:question_set_random].nil?
      @question = Question.find(session[:current_question_id])
    end
    if @question.nil?
      # 30% chance of getting sponsor_question if not signed in when count down reaches 0
      if count_down == 0 and  rand() < 0.3
        question_count = Question.by_sponsor(current_project.sponsor_id).count;
        @question = Question.by_sponsor(current_project.sponsor_id).random(question_count).first || Question.random_question(current_question_set, session_manager.answered_ids)
      else
        @question = Question.random_question(current_question_set, session_manager.answered_ids)
      end
      if !@question.nil?
        session[:current_question_id] = @question.id
      end
    end

    if @question.nil? #no more questions in dazuoxiaoti.com
      session_manager.notices << t('question.no_question')
      redirect_to root_path
    else
      #@question_set = @question.question_sets.first
      render_question
    end
  end
  def render_question
    if @question.is_sponsored?
      session_manager.set_show_sponsored
      @name = t('question.sponsor_category')
    else
      @suggested_question_sets = QuestionSet.order('id DESC').limit(5)
    end
    @choices = @question.choices
    if user_signed_in?
      @question_path = question_path @question.token, {:referer_id => current_user.id}
    else
      @question_path = question_path @question.token
    end
    respond_to do |format|
      format.html { render :show }
      format.js {render :next}
    end
  end

  def project_layout
    if [5,7,8,9,10,11,12,14,16,18,21].include? current_project.id
      "legacy/project_#{current_project.id}"
    else
      "project"
    end
  end
end