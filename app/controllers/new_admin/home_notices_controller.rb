class NewAdmin::HomeNoticesController < NewAdmin::ApplicationController
  # GET /new_admin/home_notices
  # GET /new_admin/home_notices.json
  def index
    @notices = HomeNotice.page(params["page"])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notices }
    end
  end

  # GET /new_admin/home_notices/1
  # GET /new_admin/home_notices/1.json
  def show
    @home_notice = HomeNotice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @home_notice }
    end
  end

  # GET /new_admin/home_notices/new
  # GET /new_admin/home_notices/new.json
  def new
    @home_notice = HomeNotice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @home_notice }
    end
  end

  # GET /new_admin/home_notices/1/edit
  def edit
    @home_notice = HomeNotice.find(params[:id])
  end

  # POST /new_admin/home_notices
  # POST /new_admin/home_notices.json
  def create
    @home_notice = HomeNotice.new(params[:home_notice])

    respond_to do |format|
      if @home_notice.save
        format.html { redirect_to [:new_admin,@home_notice], notice: 'Home notice was successfully created.' }
        format.json { render json: @home_notice, status: :created, location: @home_notice }
      else
        format.html { render action: "new" }
        format.json { render json: @home_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /new_admin/home_notices/1
  # PUT /new_admin/home_notices/1.json
  def update
    @home_notice = HomeNotice.find(params[:id])

    respond_to do |format|
      if @home_notice.update_attributes(params[:home_notice])
        format.html { redirect_to new_admin_home_notices_path, notice: 'Home notice was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @home_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_admin/home_notices/1
  # DELETE /new_admin/home_notices/1.json
  def destroy
    @home_notice = HomeNotice.find(params[:id])
    @home_notice.destroy

    respond_to do |format|
      format.html { redirect_to new_admin_home_notices_url }
      format.json { head :ok }
    end
  end
end
