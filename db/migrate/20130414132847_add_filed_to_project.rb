
class AddFiledToProject < ActiveRecord::Migration
  def change
    add_column :projects,:project_kind,:integer,:default=> 1
  end
end
