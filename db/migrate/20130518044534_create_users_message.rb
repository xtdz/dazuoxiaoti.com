class CreateUsersMessage < ActiveRecord::Migration
  def change
    create_table :users_messages do |t|
      t.integer :from_id
      t.integer :user_id
      t.integer :message_id
      t.boolean :is_read,:default=>false
      t.integer :status

      t.timestamps
    end
  end
end
