class Project2sController < ApplicationController
  layout :project_layout
  #before_filter :require_admin, :only => [:edit, :update, :create, :new]
  before_filter :reset_current_url_to_root, :only => [:index, :show]
  
  def show
    @project2 = Project2.find params[:id]
    if @project2.expired?
      redirect_to past_project_path(@project)
    end
    @project2s = Project2.find_all_ongoing.reverse
    @project2s.delete(@project)
  end

  def new
    @project2 = Project2.new
    @project2.build_nested_models
  end

  def create
    @project2 = Project2.new(params[:project2])
    @project2.common_data = CommonData.new(params[:common_data])
    @project2.save
    redirect_to(project2_path(@project2))
  end

  def edit
    @project2 = Project2.find(params[:id])
    @project2.build_nested_models
  end

  def update
    @project2 = Project2.find(params[:id])
    respond_to do |format|
      if @project2.update_attributes(params[:project2])
        format.html  { redirect_to(edit_project2_path(@project2),:notice => 'Project was successfully updated.') }
      end
    end
  end

  private
  def project_layout
    if params[:action] == "show" and [5,7,8,9,10,11,12,14,16,18,21].include?(params[:id].to_i)
      "legacy/project_#{params[:id]}"
    else
      (["index", "list", "new"].include? params[:action]) ? "index" : "project"
    end
  end
end
