class AddIsHotToQuestionSets < ActiveRecord::Migration
  def change
    add_column :question_sets, :is_hot, :boolean
  end
end
