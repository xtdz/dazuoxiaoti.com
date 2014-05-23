class Mobile::HomeController < ApplicationController
  before_filter :assign_project, :expire_project, :assign_other_projects, :redirect_mobile_admin, :only => [:index2]
  layout 'mobile/mobile'
  def index
  end

  def index2
  	if !session[:count_down]
      session[:count_down] = 10
    end
    count_down = session[:count_down]
    question_set_params_string = params[:question_set].nil? ? '' : '&question_set='+params[:question_set]
    session_manager.current_url = 'mobile/questions/random?project_id='+ @project.id.to_s + question_set_params_string
    
    current_question_set = params[:question_set]
    if current_question_set.nil?
      current_question_set = session[:current_question_set]
    else
      session[:current_question_set] = current_question_set
    end
    
    @question = nil
    if session[:current_question_id] && params[:question_set].nil? && params[:question_set_random].nil?
      @question = Question.find(session[:current_question_id])
    end
    if @question.nil?
      if user_signed_in?
        if count_down == 0 
          @question = current_user.get_next_sponsor_question(current_project.sponsor_id) || current_user.get_next_question(nil)
        else
          @question = current_user.get_next_question(current_question_set)
        end
      else
        # default_question_set = QuestionSet::DEFAULT_SET.to_s
        # 30% chance of getting sponsor_question if not signed in when count down reaches 0
        if count_down == 0 and  rand() < 0.3
          question_count = Question.by_sponsor(current_project.sponsor_id).count;
          @question = Question.by_sponsor(current_project.sponsor_id).random(question_count).first || Question.random_question(nil, session_manager.answered_ids)
        else
          @question = Question.random_question(nil, session_manager.answered_ids)
        end
      end
      if !@question.nil?
        session[:current_question_id] = @question.id
      end
    end

    if @question.nil? #no more questions in dazuoxiaoti.com
      session_manager.notices << t('question.no_question')
      session[:current_question_set] = nil
      respond_to do |format| #TODO
        format.html { redirect_to root_path }
        format.js { render :js => "window.location = ''" }
      end
    else
      #@question_set = @question.question_sets.first
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
    end

    # projects part
    @projects = Project.find_all_ongoing.reverse
    @past_projects = Project.find_all_expired.reverse

    #classifies part
  	@user_question_sets = current_user ? current_user.recent_sets : []
    ids = @user_question_sets.map {|question_set| question_set.id}
    cond = []
    cond=["category_id=#{params['category_id']}"] if params["category_id"]
    if ids.empty?
      @featured_question_sets = QuestionSet.order('id DESC').where(cond.join(" and "))
    else
      @featured_question_sets = QuestionSet.order('id DESC').where(['id NOT IN (?)', ids]).where(cond.join(" and ")).shuffle
    end
    @notices = session_manager.notices
  end


end