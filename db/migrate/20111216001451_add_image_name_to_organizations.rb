class AddImageNameToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :image_name, :string
  end
end
