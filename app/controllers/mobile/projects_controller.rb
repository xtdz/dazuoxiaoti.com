class Mobile::ProjectsController < ApplicationController
  before_filter :assign_project, :expire_project, :assign_other_projects

  def index
    @projects = Project.find_all_ongoing.reverse
    @past_projects = Project.find_all_expired.reverse
  end

  def show
    @project = Project.find params[:id]
    if @project.expired?
      redirect_to past_project_path(@project) and return
    end
    respond_to do |format|
      format.js { render :project_info }
    end
  end

end
