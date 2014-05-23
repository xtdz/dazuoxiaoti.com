class Mobile::ProjectsController < ApplicationController
  layout :project_layout
  before_filter :assign_project, :expire_project, :assign_other_projects, :redirect_mobile_admin
  before_filter :require_admin, :only => [:edit, :update, :create, :new]
  before_filter :reset_current_url_to_root, :only => [:index, :show]

  def index
    @projects = Project.find_all_ongoing.reverse
    @past_projects = Project.find_all_expired.reverse
  end

  def show
    @project = Project.find params[:id]
    if @project.expired?
      redirect_to past_project_path(@project)
    end
    @projects = Project.find_ongoing.reverse
    @projects.delete(@project)
  end

  private
  def project_layout
      (["index", "list", "new"].include? params[:action]) ? "mobile/index" : "mobile/projects"
  end
end
