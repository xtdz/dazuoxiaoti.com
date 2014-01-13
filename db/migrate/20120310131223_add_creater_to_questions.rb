class AddCreaterToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :user_id, :integer, :default => 0
  end
end
