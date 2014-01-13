class AddContributionToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :contribution, :integer, :default => 0
  end
end
