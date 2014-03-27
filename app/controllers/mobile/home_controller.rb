class Mobile::HomeController < ApplicationController
 	before_filter :redirect_mobile_admin
  layout 'mobile/mobile'
  def index
  end
end