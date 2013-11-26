# -*- encoding: utf-8 -*-
class NewAdmin::QuestionsController < NewAdmin::ApplicationController
  def index
  	if params["question_set_id"]
  		set = QuestionSet.find params["question_set_id"]
  		@questions = set.questions.includes(:question_trace,:question_sets).page(params[:page])
  	elsif params["title"]
      @questions = Question.includes(:question_trace).where("title like '%#{params[:title]}%'").page(params[:page])
    else

  		@questions = Question.includes(:question_trace).page(params[:page])
  	end  
  end

  def show
  	 @question = Question.find(params[:id])
  end

  def new
  	@question = Question.new
  end

  def create
    @question = Question.new(params[:question])
   
    respond_to do |format|
      if @question.save && @question.question_sets<<(QuestionSet.find params["question_set_id"])
        format.html { redirect_to new_admin_questions_path, notice: '创建成功' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question]) 
        @question.question_sets<<(QuestionSet.find params["question_set_id"]) unless @question.question_sets.find params["question_set_id"]
        format.html { redirect_to new_admin_questions_path, notice: '创建成功' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

 def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to new_admin_questions_path }
      format.json { head :no_content }
    end
  end


end
