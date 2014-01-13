class AddTimestampsToQuestionSet < ActiveRecord::Migration
  def change
    add_timestamps :question_sets_users
  end
end
