class AddFieldsToCategory < ActiveRecord::Migration
  def change
  	 add_column :categories, :is_show, :boolean,:default=>true
  	 add_column :categories,:icon,:string
  	 add_column :categories,:icon_file_name,:string
  	 add_column :categories,:icon_updated_at,:datetime
  	 add_column :categories,:icon_file_size,:string
  	 add_column :categories,:icon_content_type,:string


  end
end
