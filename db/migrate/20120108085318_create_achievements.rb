class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :label
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
