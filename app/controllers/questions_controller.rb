# -*- encoding: utf-8 -*-
class QuestionsController < ApplicationController
  layout :project_layout
  before_filter :assign_project, :expire_project, :assign_other_projects, :except => [:like, :search]
  before_filter :disable_robot_index, :only => [:show]
  before_filter :require_admin, :only => [:edit, :update, :search, :destroy]
  before_filter :check_mobile
  def show
    session_manager.current_url = '/questions/random?project_id='+ @project.id.to_s
    @question = Question.find_by_token params[:id]

    if !@question.nil?
      @question_set = @question.question_sets.first
      render_question
    else
      redirect_to :action => :random
    end
  end

  def new
    @question = Question.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  def edit
    @question = Question.includes(:question_sets).find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(params[:question])
        question_sets = QuestionSet.find_all_by_id(params[:qs])
        @question.question_sets = question_sets 
        format.html  { redirect_to(edit_question_path(@question),:notice => 'Question was successfully updated.') }
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.destroy
        format.html  { redirect_to(pending_questions_path, :notice => 'Question was successfully deleted.') }
      end
    end
  end

  def skip
  	session.delete(:current_question_id)
  	session_manager.count_down
    @question = Question.find(params[:id])
    @answer = @question.answers.new(:state => 2)
    QuestionTrace.record_answer(@question,nil,false)
    if user_signed_in?
      current_user.add_answer_for_project @answer, current_project
    else
      session_manager.add_answer(@answer)
    end
    respond_to do |format|
      format.html { redirect_to :action => :random}
      format.js   { random }
    end
  end
  
  def random
    if !session[:count_down]
      session[:count_down] = 10
    end
    count_down = session[:count_down]
    question_set_params_string = params[:question_set].nil? ? '' : '&question_set='+params[:question_set]
    session_manager.current_url = '/questions/random?project_id='+ @project.id.to_s + question_set_params_string

    current_question_set = session[:current_question_set]
    if params.has_key?(:question_set)
      session[:current_question_set] = params[:question_set]
      current_question_set = params[:question_set]
    elsif params.has_key?(:question_set_random)
      session.delete(:current_question_set)
      current_question_set = nil
    end
	
    @question = nil
    if session[:current_question_id] && params[:question_set].nil? && params[:question_set_random].nil?
      @question = Question.find(session[:current_question_id])
    end
    if @question.nil?
      if user_signed_in?
        if count_down == 0
          @question = current_user.get_next_project_question(current_project.id) || current_user.get_next_question(current_question_set)
        else
          @question = current_user.get_next_question(current_question_set)
        end
      else
        # default_question_set = QuestionSet::DEFAULT_SET.to_s
        # 30% chance of getting sponsor_question if not signed in when count down reaches 0
        if count_down == 0 and  rand() < 0.3
          question_count = Question.by_project(current_project.id).count
          @question = Question.by_project(current_project.id).random(question_count).first || Question.random_question(current_question_set, session_manager.answered_ids)
        else
          @question = Question.random_question(current_question_set, session_manager.answered_ids)
        end
      end
      if !@question.nil?
        session[:current_question_id] = @question.id
      end
    end
    if session[:correct_count] && session[:correct_count] > 9 && !user_signed_in?
      redirect_to_registration
    elsif @question.nil? #no more questions in selected sets
      session_manager.notices << t('question.no_question')
      redirect_to_question_sets
    else
      @question_set = @question.question_sets.first
      render_question
    end
  end
  def like
    @question = Question.find(params[:id])
    @question.liked_count += 1
    @question.save
    session_manager.liked << @question.id
    respond_to do |format|
      format.js {render :js => "$('.like').html('" + t('question.liked') + " " + @question.liked_count.to_s + "');"}
    end
  end

  def search
    @questions = Question.search(params[:q])
    respond_to do |format|
      format.js {render :search}
    end
  end

  private

  def render_question
    if @question.is_sponsored?
      session_manager.set_show_sponsored
      @name = t('question.sponsor_category')
    elsif @question.is_project_question?
      @name = t('question.project_category')
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

  def redirect_to_registration
    session_manager.current_url= "/questions/random?project_id=#{@project.id}"
    respond_to do |format|
      format.html { redirect_to new_user_registration_path + '?fr=q', notice: "您已经答对10道题，请您点击下方的新浪微博、人人账号、腾讯微博登录，方可继续答题，登录后还会有更多功能，感谢您的参与！期待您来贡献更多正能量！" }
      format.js {render :js => "window.location = '/questions/random?project_id=#{@project.id}'"}
    end
  end

  def redirect_to_survey
    respond_to do |format|
      format.html { redirect_to random_surveys_path(:project_id => @project.id)}
      format.js {render :js => "window.location = '/surveys/random?project_id=#{@project.id}'"}
    end
  end

  #TODO: redirect to question_sets instead
  def redirect_to_question_sets

    respond_to do |format|
      format.html { redirect_to classifies_path,notice: "请您选择一些题集进行答题!" }
      format.js {render :js => "window.location = '/classifies'"}
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
