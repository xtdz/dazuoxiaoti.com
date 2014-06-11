class Mobile::PastProjectsController < ApplicationController
  before_filter :redirect_mobile_admin

  def show
    @project = Project.find(params[:id])
    if !@project.expired?
      redirect_to project_path(@project) and return
    end
    respond_to do |format|
      format.js { render :project_info }
    end
  end

end
