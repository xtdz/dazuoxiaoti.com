class DropSponsors < ActiveRecord::Migration
  def up
    drop_table :sponsors
  end

  def down
    create_table :sponsors do |t|
      t.string :name
      t.timestamps
    end
  end
end
