class AddDescriptionAndImageNameToQuestionSets < ActiveRecord::Migration
  def change
    add_column :question_sets, :description, :text
    add_column :question_sets, :image_name, :string
  end
end
