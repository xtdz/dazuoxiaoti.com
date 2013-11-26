class AddLikedCountToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :liked_count, :integer, :default => 0
  end
end
