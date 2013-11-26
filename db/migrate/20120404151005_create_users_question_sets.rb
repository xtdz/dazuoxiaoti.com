class CreateUsersQuestionSets < ActiveRecord::Migration
  def change
    create_table :question_sets_users, :id => false do |t|
      t.integer :user_id
      t.integer :question_set_id
    end

    add_index :question_sets_users, [:user_id, :question_set_id]
  end
end
