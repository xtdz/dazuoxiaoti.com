class Organization < ActiveRecord::Base
  has_many :sponsored_projects, :class_name => 'Project', :foreign_key => 'sponsor_id'
  has_many :coordinated_projects, :class_name => 'Project', :foreign_key => 'coordinator_id'

  def image_path
    if image_name
      'organizations/' + image_name
    else
      'static/header/logo_text.png'
    end
  end
  
  has_attached_file :upload_image
end
