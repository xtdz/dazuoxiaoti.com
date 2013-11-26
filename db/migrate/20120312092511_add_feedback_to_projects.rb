class AddFeedbackToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :feedback, :string
  end
end
