class CreateYixinCards < ActiveRecord::Migration
  def change
    create_table :yixin_cards do |t|
      t.string :cards
      t.string :password
      t.integer :user_id
      t.boolean :is_used,:default=>false
      t.timestamp :expire_at
      t.timestamps
    end
  end
end
