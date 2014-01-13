class SurveysController < ApplicationController
  before_filter :assign_project, :expire_project, :assign_other_projects
  before_filter :disable_robot_index, :only => [:show, :new, :random, :skip, :like]

  def random
    session[:surveys] ||= survey_ids
    if session[:surveys].empty?
      session[:count_down] = 7
      redirect_to random_questions_path(:project_id => @project.id)
    else
      if user_signed_in? 
        @user = User.find(current_user.id)
      end
      @survey = Survey.find session[:surveys].pop
      @choices = @survey.choices
      respond_to do |format|
        format.html { render "show.html" }
        format.json { render json: @survey }
      end
    end
  end

  def fillup
    @survey = Survey.find(params[:id])
    @survey.increase_count(params[:index])
    if @survey.save
      session[:surveys].delete(params[:id])
      session[:count_down] = 6
      redirect_to random_questions_path(:project_id => @project.id)
    end
  end

  private
  def survey_ids
    arr = []
    Survey.find(:all, :conditions => ['id > ?', 8]).each {|s| arr << s.id.to_s}
    arr.shuffle!
  end
end
