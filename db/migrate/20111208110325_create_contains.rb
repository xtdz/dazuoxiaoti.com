class CreateContains < ActiveRecord::Migration
  def change
    create_table :contains do |t|
      t.integer :keyword_id
      t.integer :question_id
    end
  end
end
