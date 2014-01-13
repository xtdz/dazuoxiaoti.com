class AddUploadImageToQuestionSets < ActiveRecord::Migration
  def change
    add_attachment :question_sets, :upload_image
  end
end
