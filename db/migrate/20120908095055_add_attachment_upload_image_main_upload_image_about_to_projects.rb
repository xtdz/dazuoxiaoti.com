class AddAttachmentUploadImageMainUploadImageAboutToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.has_attached_file :upload_image_main
      t.has_attached_file :upload_image_about
    end
  end

  def self.down
    drop_attached_file :projects, :upload_image_main
    drop_attached_file :projects, :upload_image_about
  end
end
