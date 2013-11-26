# -*- encoding: utf-8 -*-
class Message < ActiveRecord::Base

  after_create :deal_all_messages
  def deal_all_messages
  	return if kind.to_i!=2
  	User.select("id").find_each do |u|
  		UsersMessage.create({:from_id=>-1,:user_id=>u.id,:message_id=>id})
  	end
  end

  def self.send_message(from_id,to_id,msg={})
  	return if msg.blank?
  	m = Message.create(msg)
    UsersMessage.create({:from_id=>from_id,:user_id=>to_id,:message_id=>m.id})
  end
end
