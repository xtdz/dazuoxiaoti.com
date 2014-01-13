class AddFieldToQuestionSets < ActiveRecord::Migration
  def change
  	add_column :question_sets,:category_id,:integer
  	add_index :question_sets,:category_id
  end

end
