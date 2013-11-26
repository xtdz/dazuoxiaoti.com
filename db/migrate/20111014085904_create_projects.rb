class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :beneficiary
      t.integer :skipped_count,          :default => 0
      t.integer :correct_count,       :default => 0
      t.integer :incorrect_count,     :default => 0
      t.integer :participation_count, :default => 0
      t.integer :limit,               :default => 0
      t.integer :rate,                :default => 1

      t.timestamps
    end
  end
end
