class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.integer :project_id
      t.string :content

      t.timestamps
    end
  end
end
