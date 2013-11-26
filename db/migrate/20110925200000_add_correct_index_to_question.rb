class AddCorrectIndexToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :correct_index, :integer
  end
end
