class SessionManager
  extend ActiveSupport::Memoizable
  attr_accessor :session, :controller

  def initialize(session, controller)
    self.session= session
    self.controller= controller
    self.expires_at = Time.now + 1.week
  end

  def all_projects_on_going
    (Project.find_ongoing + Project2.find_ongoing).sort_by{|p| p.created_at}
  end

  #TODO: the current_project logic currently causes no error, but it is messed up....
  def current_project_id
    session[:current_project_id] ||= current_project ? current_project.id : all_projects_on_going.last.id
  end

  def current_project_type
    session[:current_project_type] ||= current_project ? current_project.class.to_s : all_projects_on_going.last.class.to_s
  end

  def current_project_type= type
    session[:current_project_type] = type.to_s if type
  end
  
  def current_project_id= id
    session[:current_project_id] = id.to_i if id
  end

  def current_project
    if session[:current_project_type] == "Project"
      if session[:current_project_id]
        Project.find(session[:current_project_id])
      elsif signed_in?
        current_user.most_recent_project
      else
        all_projects_on_going.last
      end
    else
      if session[current_project_id]
        Project2.find(session[:current_project_id])
      elsif signed_in?
        all_projects_on_going.last
      end  
    end
  end

  def add_answer(answer)
    self.expires_at = Time.now + 6.hours
    if answer.correct?
      self.correct_count += 1
    end
    current_project_answers << answer.serialize
    current_project.increment answer.counter_name
    if !answer.skipped? and new_participation?
      current_project.increment :participation_count
      mark_participation
    end
  end

  def new_participation?
    participations[current_project_id].nil?
  end

  def mark_participation
    participations[current_project_id] = true
  end

  def participations
    session[:participations] ||= {}
    session[:participations][current_project_type] ||= {}
  end

  def current_project_answers
    answers[current_project_id] ||= []
  end

  def answers
    session[:answers] ||= {}
    session[:answers][current_project_type] ||= {}
  end

  def answered_ids
    answers.values.flatten.map {|answer| answer[:question_id]}
  end

  def notices
    session[:notices] ||= []
  end

  def liked
    session[:liked] ||= []
  end

  def current_url
    session[:current_url] ||= '/'
  end

  def current_url= url
    session[:current_url] = url
  end

  def expires_at
    session[:expires_at] ||= Time.now + 6.hours
  end

  def expires_at= time
    session[:expires_at] = time
  end

  def set_show_sponsored
    session[:is_showed] = true
  end

  def is_show_sponsored?
    session[:is_showed]
  end

  def correct_count
    session[:correct_count] ||= 0
  end

  def correct_count= count
    session[:correct_count] = count
  end

  def count_down
    session[:count_down] = session[:count_down] && session[:count_down] > 0 ? session[:count_down] - 1 : 10
  end

  def referer
    @referer ||= referer_id ? User.where(:id => referer_id).first : nil
  end

  def referer_id
    session[:referer_id]
  end

  def referer_id= id
    session[:referer_id] = id
  end


  memoize :current_project

  private
  def signed_in?
    controller.signed_in?
  end

  def current_user
    controller.current_user
  end
end
