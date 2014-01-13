class AddTokenToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :token, :string
  end
end
