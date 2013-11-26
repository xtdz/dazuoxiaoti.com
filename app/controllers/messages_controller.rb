# -*- encoding: utf-8 -*-
class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@messages = current_user.messages.page(params[:page]).per(6)	
  end

  def show
    @message = current_user.messages.find_by_id params[:id]
    UsersMessage.where("user_id=? and message_id=?",current_user.id,params[:id]).update_all(:is_read=>true)
  	#@message.update_attributes({:is_read=>true})
  end

  def delete
    UsersMessage.where("user_id=? and message_id in(?)",current_user.id,params["msg_id"]).delete_all
    flash[:notice]="删除成功"
    redirect_to messages_path
  end
  def destroy
  	ids = current_user.messages.where("id in(?)", params[:id]).map(&:id)
    UserMessage.destroy(ids)
  end

end
