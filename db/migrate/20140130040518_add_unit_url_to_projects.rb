class AddUnitUrlToProjects < ActiveRecord::Migration
  def change
  	add_column :benefits, :unit_url, :string
  end
end
