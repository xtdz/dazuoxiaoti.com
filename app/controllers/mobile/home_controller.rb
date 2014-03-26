class Mobile::HomeController < ApplicationController
 	before_filter :require_mobile_admin
  layout 'mobile/mobile'
  def index
  end
end