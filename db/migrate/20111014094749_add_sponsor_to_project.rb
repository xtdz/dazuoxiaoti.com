class AddSponsorToProject < ActiveRecord::Migration
  def change
    add_column :projects, :sponsor_id, :integer
  end
end
