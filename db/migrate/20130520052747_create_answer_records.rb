class CreateAnswerRecords < ActiveRecord::Migration
  def change
    create_table :answer_records do |t|
      t.integer :user_id
      t.integer :correct_count,:default=>0
      t.timestamp :answer_at

      t.timestamps
    end
  end
end
