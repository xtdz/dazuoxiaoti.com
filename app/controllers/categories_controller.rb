class CategoriesController < ApplicationController
  before_filter :assign_project, :expire_project, :only => [:index]

  def index
    if user_signed_in?
      @projects = Project.where(["end_time > ?", Time.now]).reverse
      @projects.delete(@project)
      @categories = Category.all
      @user = current_user
    else
      redirect_to root_path
    end
  end
  
  def update_categories_to_user
    if user_signed_in?
      @user = User.find(current_user.id)
      @user.update_category_bits(Integer(params[:id]), params[:wanted])
    end
    respond_to do |format|
      format.js {render :file => "categories/update"}
    end
  end

end
