class AddRankToParticipation < ActiveRecord::Migration
  def change
    add_column :participations, :contribution_rank, :integer
  end
end
