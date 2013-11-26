class AddStepsToBenefits < ActiveRecord::Migration
  def change
    add_column :benefits, :steps, :integer, :default => 1
  end
end
