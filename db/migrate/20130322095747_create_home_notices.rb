class CreateHomeNotices < ActiveRecord::Migration
  def change
    create_table :home_notices do |t|
      t.string :url
      t.string :title
      t.boolean :is_top
      t.timestamps
    end
  end
end

