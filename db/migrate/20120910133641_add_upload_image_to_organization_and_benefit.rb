class AddUploadImageToOrganizationAndBenefit < ActiveRecord::Migration
  def self.up
    add_attachment :organizations, :upload_image
    add_attachment :benefits, :upload_image
  end

  def self.down
    remove_attachment :organizations, :upload_image
    remove_attachment :benefits, :upload_image
  end
end
