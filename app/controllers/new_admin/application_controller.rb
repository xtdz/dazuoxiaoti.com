class NewAdmin::ApplicationController < ApplicationController
  layout 'admin'
  
  before_filter :authenticate 

  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "vjoin"
    end
  end
  
end
