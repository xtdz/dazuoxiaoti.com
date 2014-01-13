class AddDescriptionToBenefits < ActiveRecord::Migration
  def change
    add_column :benefits, :description, :text
  end
end
