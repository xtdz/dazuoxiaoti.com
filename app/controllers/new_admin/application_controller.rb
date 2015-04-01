# -*- encoding: utf-8 -*-
class NewAdmin::ApplicationController < ApplicationController
  layout 'admin'
  
  before_filter :authenticate 

  def authenticate
    unless user_signed_in?
      session_manager.current_url = '/new_admin'
      redirect_to new_user_session_path, :notice => '请先登陆'
    end
    redirect_to root_path unless current_user.is_admin?
  end
  
end
