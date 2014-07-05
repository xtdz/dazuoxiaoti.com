class MoveUnitRateToProjectDomain < ActiveRecord::Migration
  def change
  	remove_column :benefits, :unit_rate
  	add_column :projects, :unit_rate, :integer, :default => 1
  end
end
