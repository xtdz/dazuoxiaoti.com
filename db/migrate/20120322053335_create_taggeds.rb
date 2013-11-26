class CreateTaggeds < ActiveRecord::Migration
  def change
    create_table :taggeds do |t|
      t.integer :question_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
