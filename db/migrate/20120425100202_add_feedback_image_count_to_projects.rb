class AddFeedbackImageCountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :feedback_image_count, :integer, :default => 0
  end
end
