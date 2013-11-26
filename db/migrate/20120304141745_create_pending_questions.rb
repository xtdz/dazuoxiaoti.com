class CreatePendingQuestions < ActiveRecord::Migration
  def change
    create_table :pending_questions do |t|
      t.string :title
      t.string :c1
      t.string :c2
      t.string :c3
      t.string :c4
      t.text :explanation
      t.string :keyword
      t.integer :state, :default => 0
      t.text :comment
      t.references :user

      t.timestamps
    end
  end
end
