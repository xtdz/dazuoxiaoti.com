# -*- encoding: utf-8 -*-
class NewAdmin::YixinCardsController < NewAdmin::ApplicationController
  def index
  	con = []
  	con.push("cards=#{params[:card]}") if params["card"]
  	@cards = YixinCard.includes([:user]).where(con.join(" and ")).page(params[:page])
  	@send_cards = YixinCard.where("user_id is not null").count
  	@user_num = YixinCard.where("user_id is not null").select("distinct(user_id)").count
  end

  def new
  end
  
  def create
    begin
      sheet = Spreadsheet.open(params[:file].tempfile.path).worksheet(0)
    rescue
      redirect_to :action => 'new'
      flash[:notice] = "文件读取错误。请确认文件格式是否正确后再上传" 
      return nil
    end
    sheet.each do |row|    
      next if row[0] == nil
      YixinCard.create({"cards"=>row[0],"password"=>row[1],"expire_at"=>params["date"]})
    end
    respond_to do |format|
      format.html { redirect_to :action => 'index' ,flash[:notice] => "上传成功" }
    end


  end

end
