class Asset < ActiveRecord::Base
  attr_accessible :upload_image,:upload_image_file_name,:link, :is_top

  validates :upload_image,:presence => true,:on=>"create"

  has_attached_file :upload_image#, :styles => { :medium => "250x230" }

  def image_path
    if image_name
      "homes/#{image_name}"
    end
  end
  
end
