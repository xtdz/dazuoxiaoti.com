class DropCoordinators < ActiveRecord::Migration
  def up
    drop_table :coordinators
  end

  def down
    create_table :coordinators do |t|
      t.string :name

      t.timestamps
    end
  end
end
