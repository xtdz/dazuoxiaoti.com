class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def main
    @participations = current_user.recent_participations
  end

  def questions
    @accepted_questions = current_user.questions.includes(:answers)
    @rejected_questions = PendingQuestion.where("state = 2 AND user_id = ?", current_user.id)
    @pending_questions = PendingQuestion.where("state = 0 AND user_id = ?", current_user.id)
  end
end
