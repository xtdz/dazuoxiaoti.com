# -*- encoding: utf-8 -*-
class NewAdmin::QuestionSetsController < NewAdmin::ApplicationController
  def index
  	con = []
    con.push("category_id=#{params['category_id']}") if params["category_id"]
    con.push("name like '%#{params["name"]}%'") if params["name"]
    @sets = QuestionSet.includes(:category,:question_traces).where(con.join(" and ")).page(params[:page]).per(15)
  
  end

  def show
  	 @question_set = QuestionSet.find(params[:id])
  end

  def new
  	@question_set = QuestionSet.new
  end

  def create
    @question_set = QuestionSet.new(params[:question_set])
    
    respond_to do |format|
      if @question_set.save
        format.html { redirect_to new_admin_question_sets_path, notice: '创建成功' }
        format.json { render json: @question_set, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @question_set.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @question_set = QuestionSet.find(params[:id])
  end

  def update
    @question_set = QuestionSet.find(params[:id])

    respond_to do |format|
      if @question_set.update_attributes(params[:question_set])
        format.html { redirect_to new_admin_question_sets_path, notice: '创建成功' }
        format.json { render json: @question_set, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @question_set.errors, status: :unprocessable_entity }
      end
    end
  end


 def destroy
    @doc = QuestionSet.find(params[:id])
    @doc.destroy

    respond_to do |format|
      format.html { redirect_to new_admin_question_sets_path }
      format.json { head :no_content }
    end
  end

end
