class AddCategoryToUser < ActiveRecord::Migration
  def change
    add_column :users, :category_bits, :integer, :default => 0
  end
end
