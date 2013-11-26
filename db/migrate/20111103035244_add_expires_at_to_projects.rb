class AddExpiresAtToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :expires_at, :datetime
  end

  def down
    remove_column :projects, :expires_at
  end
end
