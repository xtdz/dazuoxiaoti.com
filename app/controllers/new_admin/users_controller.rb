class NewAdmin::UsersController < NewAdmin::ApplicationController
  def index
  	cons = []
  	cons.push("nickname like '%#{params[:nickname]}%'") if params["nickname"]
  	@users = User.where(cons.join(" and ")).page(params["page"])
  end

end
