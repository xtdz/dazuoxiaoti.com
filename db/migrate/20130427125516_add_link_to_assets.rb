class AddLinkToAssets < ActiveRecord::Migration
  def change
  	 add_column :assets,:link,:string
  end
end
