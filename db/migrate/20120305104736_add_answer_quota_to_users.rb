class AddAnswerQuotaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :answer_quota, :integer, :default => 50
  end
end
