class Users::RegistrationsController < Devise::RegistrationsController
  after_filter :add_answers, :only => [:create]
  #after_filter :clear_category_bits, :only => [:create]

  def add_answers
    if resource.persisted? and session[:answers]
      session[:answers].each do |project_id, answers|
        project = Project.find project_id
        if project
          answers ||= []
          answers = answers.map {|a| (a.is_a? Answer) ? a : Answer.new(a)}
          referer = session[:referer_id] ? User.find(session[:referer_id]) : nil
          resource.add_answers_for_project answers, project, referer
        end
      end
    end
  end

  def clear_category_bits
    if resource.persisted?
      last_id = Category.last.id
      bits = 0b0
      last_id.times {bits = (bits << 1) | 0b1}
      resource.category_bits = bits
      resource.save
    end
  end
end
