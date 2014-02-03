class AddUnitRate < ActiveRecord::Migration
  def change
  	add_column :benefits, :unit_rate, :integer, :default => 1
  end
end
