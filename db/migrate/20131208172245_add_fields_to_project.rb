class AddFieldsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :information, :string
    add_column :projects, :share_question_text, :string
    add_column :projects, :share_finish_text, :string
    add_attachment :projects, :upload_image_small
    add_attachment :projects, :upload_image_banner
    add_attachment :projects, :upload_image_share_question1
    add_attachment :projects, :upload_image_share_question2
    add_attachment :projects, :upload_image_share_finish1
    add_attachment :projects, :upload_image_share_finish2
  end
end
