class AddIntendedForSetToPendingQuestions < ActiveRecord::Migration
  def change
    add_column :pending_questions, :intended_for_set, :integer
  end
end
