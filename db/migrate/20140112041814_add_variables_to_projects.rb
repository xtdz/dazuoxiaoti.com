class AddVariablesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :banner_url, :string, :default => "http://www.dazuoxiaoti.com"
    add_column :projects, :tab_show_num, :integer, :default => 0
    add_column :projects, :unit_rate, :integer, :default => 1
    add_column :projects, :customed_name, :string
    add_column :projects, :customed_url, :string, :default => "http://www.dazuoxiaoti.com"
    add_column :projects, :customed_description, :string
    add_column :benefits, :unit_url, :string
    add_attachment :projects, :upload_image_customed
  end
end
