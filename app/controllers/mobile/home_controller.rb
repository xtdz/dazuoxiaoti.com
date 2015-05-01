class Mobile::HomeController < ApplicationController
  before_filter :assign_project, :expire_project, :assign_other_projects, :only => [:index]
  layout 'mobile'

  def index
    # question part
    question_set_params_string = params[:question_set].nil? ? '' : '&question_set='+params[:question_set]
    question_url = '/mobile/questions/random.js?project_id='+ @project.id.to_s + question_set_params_string
    @random_question_js = "$(document).on('pageinit', '#pageone', function(){$.get('#{question_url}')})"
    
    session[:current_question_set] = params[:question_set] if params[:question_set]

    # projects part
    @projects = Project.find_all_ongoing.reverse
    @past_projects = Project.find_all_expired.reverse_order.limit([2, 6 - @projects.count].max)

    # question sets part
    @user_question_sets = current_user ? current_user.recent_sets : []
    ids = @user_question_sets.map {|question_set| question_set.id}
    cond = ["hidden = false"]
    cond.push("category_id=#{params['category_id']}") if params["category_id"]
    if ids.empty?
      @featured_question_sets = QuestionSet.order('id DESC').where(cond.join(" and "))
    else
      @featured_question_sets = QuestionSet.order('id DESC').where(['id NOT IN (?)', ids]).where(cond.join(" and ")).shuffle
    end
    @notices = session_manager.notices
  end

end