class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :skipped_count,   :default => 0
      t.integer :correct_count,   :default => 0
      t.integer :incorrect_count, :default => 0

      t.timestamps
    end
  end
end
