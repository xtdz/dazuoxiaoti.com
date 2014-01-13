class CreateQuestionSetsQuestions < ActiveRecord::Migration
  def change
    create_table :question_sets_questions, :id => false do |t|
      t.integer :question_set_id
      t.integer :question_id
    end

    add_index :question_sets_questions, [:question_set_id, :question_id]
  end
end
