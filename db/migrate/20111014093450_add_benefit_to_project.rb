class AddBenefitToProject < ActiveRecord::Migration
  def change
    add_column :projects, :benefit_id, :integer
  end
end
