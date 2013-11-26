class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :image_name
      t.string :url

      t.timestamps
    end
  end
end
