# -*- encoding: utf-8 -*-
class NewAdmin::QuestionsController < NewAdmin::ApplicationController
  def index
  	if params["question_set_id"]
  		set = QuestionSet.find params["question_set_id"]
  		@questions = set.questions.includes(:question_trace,:question_sets,:user).page(params[:page])
  	elsif params["title"]
      @questions = Question.includes(:question_trace,:user).where("title like '%#{params[:title]}%'").page(params[:page])
    elsif params["show"]
       @questions = Question.includes(:question_trace,:user).where("sponsor_id > 0 OR project_id > 0").page(params[:page])
    else 
  		@questions = Question.includes(:question_trace,:user).page(params[:page])
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

    session_manager.current_url=request.referer || new_admin_questions_path

    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(params[:question]) 
        @question.question_sets.delete_all
        @question.question_sets<<(QuestionSet.find params["question_set_id"]) unless @question.question_set_ids.include? params["question_set_id"]
        format.html { redirect_to session_manager.current_url, notice: '修改成功' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload

  end
  def upload_sponsor
   
    begin
      sheet =  Spreadsheet.open(params[:file].tempfile.path).worksheet(0)
    rescue
      redirect_to :action => 'upload'
      flash[:notice] = "文件读取错误。请确认文件格式是否正确后再上传" 
      return nil
    end
    intended_for_set = params["question"]["intended_for_set"]
    question_set = QuestionSet.find(intended_for_set)
   # @new_questions = []
    sheet.each do |row|
      question = Question.new
      next if row[0] == nil
      # This is magic
      (1..4).each do |n|
        eval "question.c#{n} = row[#{n}]"
      end
      #
      row[5] = "" if row[5].nil?
      # Are there any methods like [var1,var2,var3] = [1,2,3]
      question.title = row[0]
      question.explanation = row[5]
     # question.keyword = row[6]
      question.sponsor_id = 0
      question.project_id = params["question"]["project_id"]
      #question.intended_for_set = intended_for_set || 62
      question.user_id = params["user_id"] || current_user.try(:id)
      question.correct_index = 1
      question.save
      question.question_sets << question_set
     # @new_questions.push question
     
    end
   # @pending_questions = @new_questions
    #render :tempfile=>"index"
    respond_to do |format|
      format.html { redirect_to :action => 'index',:notice=>"导入成功" }
    end

  end

 def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end


end
