class Keyword < ActiveRecord::Base
  has_many :questions, :through => :contains
  has_many :contains
end
