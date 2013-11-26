class NewAdmin::AssetsController < NewAdmin::ApplicationController
 
  def index
  	@pics = Asset.order("is_top,id desc")
  end

  def new
  	@pic = Asset.new
  end

  def create
     @pic = Asset.new(params[:asset])
    
    respond_to do |format|
      if @pic.save
        format.html { redirect_to new_admin_assets_path, notice: 'ok' }
        format.json { render json: @pic, status: :created, location: @pic }
      else
        format.html { render action: "new" }
        format.json { render json: @pic.errors, status: :unprocessable_entity }
      end
    end

  end

   # GET /new_admin/home_notices/1/edit
  def edit
    @pic = Asset.find(params[:id])
  end


  # PUT /new_admin/home_notices/1
  # PUT /new_admin/home_notices/1.json
  def update
    @pic = Asset.find(params[:id])

    respond_to do |format|
      if @pic.update_attributes(params[:asset])
        format.html { redirect_to new_admin_assets_path, notice: 'ok' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pic.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    pic = Asset.find params[:id]
    pic.destroy
    respond_to do |format|
      format.html { redirect_to new_admin_assets_url }
      format.json { head :ok }
    end
  end

end
