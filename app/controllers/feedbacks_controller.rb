class FeedbacksController < ApplicationController
  before_filter :require_admin, :only => [:index]
  def index
    @feedbacks = Feedback.all
  end
  
  def new
    @question = Question.find(params[:question_id])
    if params[:modal]
      render :modal_new, :layout => false
    else
      redirect_to root_path
    end
  end
  
  def create
    @question = Question.find(params[:question_id])
    @feedback = @question.feedbacks.create(params[:feedback])
    @feedback.user_id = current_user.id
    if @feedback.save
      respond_to do |format|
        format.js { render :create }
      end
    end
  end
  
end
