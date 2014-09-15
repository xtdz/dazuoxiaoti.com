class CommonDataController < ApplicationController
  def new
    @context = context
    @interaction = @context.common_data.new
  end

  def create
    @context = context
    @interaction = @context.common_data.new(common_data_params)

    if @interaction.save
      redirect_to context_url(context)
    end
  end

  def edit
    @context = Project.all.first
    @interaction = context.common_data
  end

  def update
    @context = context
    @interaction = @context.common_data.find(params[:id])
    if @interaction.update_attributes(common_data_params)
      redirect_to context_url(context)
    end
  end

private
  def commom_data_params
    params.require(:common_data).permit!
  end

  def context
    if !params[:project_id].nil?
      id = params[:project_id]
      return Project.find(params[:project_id])
    else
      id = params[:project2_id]
      return Project2.find(params[:project2_id])
    end
  end 

  def context_url(context)
    if Person === context
      project_path(context)
    else
      project2_path(context)
    end
  end
end
