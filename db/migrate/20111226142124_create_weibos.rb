class CreateWeibos < ActiveRecord::Migration
  def change
    create_table :weibos do |t|
      t.integer :project_id
      t.string :provider
      t.string :uid
      t.string :tag
      t.string :token

      t.timestamps
    end
  end
end
