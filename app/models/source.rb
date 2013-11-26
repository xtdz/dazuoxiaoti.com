class Source < ActiveRecord::Base
  def image_path
    "sources/#{image_name}"
  end
end
