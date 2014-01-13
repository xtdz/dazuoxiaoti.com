class RemoveAnswerLimitFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :answer_limit
  end

  def down
    add_column :projects, :answer_limit, :integer, :default => 100
  end
end
