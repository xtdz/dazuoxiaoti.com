class AddAnswerLimitToProject < ActiveRecord::Migration
  def change
    add_column :projects, :answer_limit, :integer, :default => 100
  end
end
