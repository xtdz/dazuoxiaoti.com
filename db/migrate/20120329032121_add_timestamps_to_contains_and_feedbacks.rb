class AddTimestampsToContainsAndFeedbacks < ActiveRecord::Migration
  def change
    change_table :contains do |t|
       t.timestamps
    end
    change_table :feedbacks do |t|
       t.timestamps
    end
  end
end
