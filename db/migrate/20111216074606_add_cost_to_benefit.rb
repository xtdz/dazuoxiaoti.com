class AddCostToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :cost, :integer
  end
end
