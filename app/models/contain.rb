class Contain < ActiveRecord::Base
  belongs_to :question
  belongs_to :keyword
end
