class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.boolean :is_top
      t.attachment :upload_image
      t.timestamps
    end
  end
end
