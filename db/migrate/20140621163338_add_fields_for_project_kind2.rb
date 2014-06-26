class AddFieldsForProjectKind2 < ActiveRecord::Migration
  def change
  	add_column :projects, :coordinator_label, :string
  	add_column :projects, :equation_string, :string
  	add_column :projects, :tagline2, :string
  	add_column :projects, :label_content, :string
  end
end
