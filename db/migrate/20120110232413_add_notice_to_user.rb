class AddNoticeToUser < ActiveRecord::Migration
  def change
    add_column :users, :notice, :integer, :default => 0
  end
end
