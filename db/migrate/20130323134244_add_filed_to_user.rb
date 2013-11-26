class AddFiledToUser < ActiveRecord::Migration
  def change
  	add_column :users,:rank_score,:integer,:default=>0
  	add_column :users,:set_question_num,:integer,:default=>0
  	add_index :users,:rank_score
  end
end
