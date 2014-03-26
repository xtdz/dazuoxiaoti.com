# encoding: utf-8
class Benefit < ActiveRecord::Base
  has_attached_file :upload_image
  validates_attachment_content_type :upload_image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  def image_path
    "benefits/#{image_name}"
  end

  def icon_path
    "benefits/#{icon_name}"
  end

  def progress_path user_correct_count, project_rate
    "benefits/#{id}/progress#{step user_correct_count, project_rate}.jpg"
  end

  def step user_correct_count, project_rate
    remainder = user_correct_count % project_rate
    if remainder == 0
      user_correct_count > 0 ? steps : 0
    else
      remainder/ (project_rate / steps)
    end
  end

  def short_name
    if id == 18
      '阅读计划'
    elsif name.length > 2
      name[-2] + name[-1]
    else
      name
    end
  end
end
