class SinaApp::QuestionSetsController < SinaApp::ApplicationController
  before_filter :authenticate_user!, :assign_project
  respond_to :json

  def index
    @question_sets = QuestionSet.all
    @question_sets.shuffle

    json_array = []
    @question_sets.each do |question_set|
      json_array << {
        id: question_set.id,
        name: question_set.name,
        description: question_set.description,
        image_path: ActionController::Base.helpers.asset_path(question_set.image_path)
      }
    end

    respond_with json_array
  end

  def show
    if (question_set = QuestionSet.find params[:id])
      current_user.question_sets.delete_all
      current_user.question_sets << question_set
    end

    status = {:success => true}

    respond_with status
  end
end
