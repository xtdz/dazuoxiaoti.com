class AddCoordinatorToProject < ActiveRecord::Migration
  def change
    add_column :projects, :coordinator_id, :integer
  end
end
