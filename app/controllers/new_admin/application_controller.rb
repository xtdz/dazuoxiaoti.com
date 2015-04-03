class NewAdmin::ApplicationController < ApplicationController
  layout 'admin'
  
  before_filter :authenticate 

  def authenticate
    unless user_signed_in?
      session_manager.current_url = '/new_admin'
      return redirect_to new_user_session_path, :notice => t('new_admin.login_required')
    end
    redirect_to root_path unless current_user.is_admin?
  end
  
end
