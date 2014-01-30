class AddBannerUrlToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :banner_url, :string
  end
end
