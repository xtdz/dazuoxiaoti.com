class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :session_expiry, :assign_referer

  def assign_project
    session_manager.current_project_id = params[:project_id]
    @project ||= current_project
    if @project.nil?
      redirect_to root_path
    end
  end

  def assign_other_projects
    @projects = Project.find_all_ongoing.reverse
    @projects.delete(@project)
  end

  def session_manager
    @session_manager ||= SessionManager.new session, self
  end

  def reset_current_url_to_root
    session_manager.current_url = '/'
  end

  def current_project
    @project ||= session_manager.current_project ? session_manager.current_project : Project.find_ongoing.last
  end

  def expire_project
    if @project.expired?
      if @project.id == 26
        @project = Project.find(28)
        @project = Project.find_ongoing.last if @project.expired?
      else
        @project = Project.find_ongoing.last
      end
    end
    if @project.nil?
      redirect_to root_path, :notice => "all projects finished."
    end
  end

  def disable_robot_index
    @metarobots = "noindex,nofollow"
  end

  def session_expiry
    if session[:expires_at] and session[:expires_at] < Time.now
       reset_session
    end
  end

  def assign_referer
    if params[:referer_id]
      referer = User.find(params[:referer_id])
      if referer
        session[:referer_id] = referer.id
      end
    end
  end
  
  def check_mobile
    if from_mobile?
      redirect_to mobile_root_path({:question_set => params[:question_set], :project_id => params[:project_id]})
    end
  end

  def mobile_admin?
    admin_ids = [18,798,1662,5589,8771,9883,9941,42630,49457,50150,51746,53148,53685,54277,54365,54845,57334,58379,58461]
    if(!user_signed_in? || !admin_ids.include?(current_user.id))
      false
    else 
      true
    end
  end

  def redirect_mobile_admin
    if !mobile_admin?
      redirect_to root_path
    end
  end  

  def require_admin
    admin_ids = [-1, 798, 18, 962, 792, 9387, 30630, 10435]
    if !user_signed_in? || !admin_ids.include?(current_user.id)
      redirect_to root_path
    end
  end

  def add_answer_to_session(project, answer)
    session[:answers] ||= {}
    session[:answers][project.id] ||= []
    session[:answers][project.id] << answer.serialize
  end

  def create_question_from_pending_question(p_q)
    @question = Question.new :title => p_q.title, :c1 => p_q.c1, :c2 => p_q.c2, :c3 => p_q.c3, :c4 => p_q.c4, :correct_index => p_q.correct_index, :explanation => p_q.explanation, :sponsor_id => 0, :user_id => p_q.user_id
    @question.shuffle
  end

  #Over writing devise method
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      session_manager.current_url
    else
      super
    end
  end
  def from_mobile?
     request.user_agent =~ /Mobile|Blackberry|Android|iPhone/
  end
end
