class AddCorrectIndexToPendingQuestions < ActiveRecord::Migration
  def change
    add_column :pending_questions, :correct_index, :integer
  end
end
