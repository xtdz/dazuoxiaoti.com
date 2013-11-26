class Users::SessionsController < Devise::SessionsController
  respond_to :html
  
  def destroy
    liked = session[:liked]
    super
    session[:liked] = liked
  end
end
