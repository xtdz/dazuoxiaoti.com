class ClassifiesController < ApplicationController
 # before_filter :redirect_to_registration
  before_filter :check_mobile
  def index
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
  def check_mobile
    if from_mobile? && mobile_admin?
      redirect_to '/mobile/classifies'
    end
  end
end
