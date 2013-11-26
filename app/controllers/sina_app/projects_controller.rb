class SinaApp::ProjectsController < SinaApp::ApplicationController
  before_filter :authenticate_user!, :assign_project
  respond_to :json

  def current
    @participation = Participation.get_participation(current_user, @project)
    json_hash = {
      id: @project.id,
      name: @project.name,
      equation: @project.equation,
      image_path: ApplicationController.helpers.asset_path(@project.image_path(:main)),
      correct_count: @project.correct_count,
      participation_count: @project.participation_count,
      item_count: @project.item_count,
      benefit_name: @project.benefit.short_name,
      benefit_unit: @project.benefit.unit,
      user_correct_count: @participation.correct_count,
      rate: @project.rate
    }

    if @project.benefit.steps > 1
      json_hash[:progress_image_path] = ApplicationController.helpers.asset_path(
        @project.progress_path @participation.correct_count)
    else
      json_hash[:progress_image_path] = ApplicationController.helpers.asset_path(
        @project.benefit.image_path)
    end

    respond_with json_hash
  end
end
