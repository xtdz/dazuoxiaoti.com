class RemoveColumnsFromProjects < ActiveRecord::Migration
  def change
  	remove_column :projects, :skipped_count
  	remove_column :projects, :correct_count
  	remove_column :projects, :incorrect_count
  	remove_column :projects, :participation_count
  	remove_column :projects, :coordinator_id
  	remove_column :projects, :sponsor_id
  	remove_column :projects, :start_time
  	remove_column :projects, :end_time
  	remove_column :projects, :tagline
  	remove_column :projects, :description
  	remove_column :projects, :name
  	remove_column :projects, :feedback_image_count
  	remove_column :projects, :hidden
  	remove_column :projects, :information
  	remove_column :projects, :share_question_text
  	remove_column :projects, :share_finish_text
  	remove_column :projects, :banner_url
    remove_column :proejcts, :project_kind
    remove_attachment :projects, :upload_image_main
    remove_attachment :projects, :upload_image_about
    remove_attachment :projects, :upload_image_small
    remove_attachment :projects, :upload_image_banner
    remove_attachment :projects, :upload_image_share_question1
    remove_attachment :projects, :upload_image_share_question2
    remove_attachment :projects, :upload_image_share_finish1
    remove_attachment :projects, :upload_image_share_finish2  
  end
end
