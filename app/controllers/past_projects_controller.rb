class PastProjectsController < ApplicationController
  layout :project_layout
  before_filter :reset_current_url_to_root, :only => [:show]

  def show
    @project = Project.find(params[:id])
    if !@project.expired?
      redirect_to project_path(@project)
    end
    @projects = Project.find_all_ongoing.reverse
    @projects.delete(@project)
  end

  def project_layout
    if params[:action] == "show" and [5,7,8,9,10,11,12,14,16,18].include?(params[:id].to_i)
      "legacy/project_#{params[:id]}"
    else
      "project"
    end
  end
end
