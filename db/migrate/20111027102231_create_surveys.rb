class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :title
      t.string :choice1
      t.string :choice2
      t.string :choice3
      t.string :choice4
      t.text :explanation
      t.integer :count1
      t.integer :count2
      t.integer :count3
      t.integer :count4

      t.timestamps
    end
  end
end
