class Mobile::HomeController < ApplicationController
  before_filter :assign_project, :expire_project, :assign_other_projects, :redirect_mobile_admin, :only => [:index]
  layout 'mobile'

  def index
    # question part
    question_set_params_string = params[:question_set].nil? ? '' : '&question_set='+params[:question_set]
    session_manager.current_url = 'mobile/questions/random?project_id='+ @project.id.to_s + question_set_params_string
    
    session[:current_question_set] = params[:question_set] if params[:question_set]

    # projects part
    @projects = Project.find_all_ongoing.reverse
    @past_projects = Project.find_all_expired.reverse

    # question sets part
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