class NewAdmin::ProjectsController < NewAdmin::ApplicationController
 
  def index
    @projects = Project.order("id desc")
  end

  def toggle
  	project = Project.find params[:id]
  	if project.project_kind.to_i == 1
  		project.project_kind=2 
  	else
        project.project_kind=1 
    end
    respond_to do |format|
       format.html { redirect_to new_admin_projects_path, notice: 'sucessful' } if project.save
    end
    
  	
  end



end
