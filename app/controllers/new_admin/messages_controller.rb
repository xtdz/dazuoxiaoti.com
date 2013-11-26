# -*- encoding: utf-8 -*-
class NewAdmin::MessagesController < NewAdmin::ApplicationController
  def index
  	@messages = Message.page(params[:page])
  end

  def show
  	@message = Message.find params[:id]

    respond_to do |format|
       format.html {render :layout => "popup"}
     end
  end
  def list
  	con=[]
  	con.push("user_id=#{params[:user_id]}") if params["user_id"].present?
  	con.push("message_id=#{params[:message_id]}") if params["message_id"].present?
  	#@message = Message.find params[:message_id]
  	@messages = UsersMessage.where(con.join(" and ")).page(params[:page]).includes([:sender,:user,:message])
  end
  def new
  	@message = Message.new
  end

  def create

  	message = Message.new(params["message"])
  	message.kind=2 if params["kind"]=="all"
  	message.save
  	if params["kind"]=="users"
  		params["users"].split(";").each do |user|

  			UsersMessage.create("from_id"=>-1,"user_id"=>user,"message_id"=>message.id)
  		end
  	end

  	notice = params["kind"]=="all" ? "群发会有些延时，请稍等片刻刷新。" : "发送成功"
  	redirect_to :action=>"index",:notcie=>notice
   end

end
