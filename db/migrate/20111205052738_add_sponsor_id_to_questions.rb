class AddSponsorIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :sponsor_id, :integer, :default => 0
  end
end
