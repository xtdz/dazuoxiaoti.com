class Mobile::PastProjectsController < ApplicationController
  layout :project_layout
  before_filter :reset_current_url_to_root, :only => [:show]
  before_filter :redirect_mobile_admin

  def show
    @project = Project.find(params[:id])
    if !@project.expired?
      redirect_to project_path(@project)
    end
  end

  def project_layout
      "mobile/projects"
  end
end
