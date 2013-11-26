class AddAchievementBitsToUser < ActiveRecord::Migration
  def change
    add_column :users, :achievement_bits, :binary
  end
end
