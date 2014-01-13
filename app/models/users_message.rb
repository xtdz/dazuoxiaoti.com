class UsersMessage < ActiveRecord::Base
	belongs_to :sender,:class_name=>"User",:foreign_key=>"from_id"
	belongs_to :user
	belongs_to :message
end
