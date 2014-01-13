class RemoveExpiresAtFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :expires_at
  end

  def down
    add_column :projects, :expires_at, :datetime
  end
end
