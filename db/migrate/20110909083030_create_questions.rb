class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :c1
      t.string :c2
      t.string :c3
      t.string :c4
      t.text :explanation

      t.timestamps
    end
  end
end
