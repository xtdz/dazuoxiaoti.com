class AddCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :incorrect_count, :integer, :default => 0
    add_column :users, :skipped_count, :integer, :default => 0
    add_column :users, :correct_count, :integer, :default => 0
  end
end
