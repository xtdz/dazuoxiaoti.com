class AddRefererToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :referer_id, :integer
  end
end
