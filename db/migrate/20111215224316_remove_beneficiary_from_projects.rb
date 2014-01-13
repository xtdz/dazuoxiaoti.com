class RemoveBeneficiaryFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :beneficiary
  end

  def down
    add_column :projects, :beneficiary, :string
  end
end
