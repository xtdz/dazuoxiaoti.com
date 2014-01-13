class RenameQuestionSetsUsers < ActiveRecord::Migration
  def change
    rename_table :question_sets_users, :subscriptions
  end
end
