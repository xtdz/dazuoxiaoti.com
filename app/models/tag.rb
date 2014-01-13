class Tag < ActiveRecord::Base
  has_many :taggeds
  has_many :questions, :through => :taggeds
end
