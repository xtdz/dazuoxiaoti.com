class AddImageNameToBenefits < ActiveRecord::Migration
  def change
    add_column :benefits, :image_name, :string
  end
end
