class AddHiddenToQuestionSets < ActiveRecord::Migration
  def change
  	add_column :question_sets, :hidden, :boolean, :default => false
  end
end
