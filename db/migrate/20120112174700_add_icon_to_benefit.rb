class AddIconToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :icon_name, :string
  end
end
