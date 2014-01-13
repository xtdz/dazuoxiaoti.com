class CreateQuestionTraces < ActiveRecord::Migration
  def change
    create_table :question_traces do |t|
      t.integer :question_id
      t.integer :c1_click_num,:default=>0
      t.integer :c2_click_num,:default=>0
      t.integer :c3_click_num,:default=>0
      t.integer :c4_click_num,:default=>0
      t.integer :corrent_num,:default=>0
      t.integer :skip_num,:default=>0
      t.integer :total_num,:default=>0

      t.timestamps


    end
    add_index(:question_traces,:question_id)
  end
end
