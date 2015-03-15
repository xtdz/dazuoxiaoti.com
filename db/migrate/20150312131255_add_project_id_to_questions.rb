class AddProjectIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :project_id, :integer, :default => 0
    add_index :questions, :project_id
  end
end
