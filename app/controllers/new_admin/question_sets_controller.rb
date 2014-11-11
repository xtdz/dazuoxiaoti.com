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

  def export
    @question_set = QuestionSet.find(params[:id])
    respond_to do |format| 
      format.xls { 
        send_data(to_xls(@question_set), :type=>:xls, :filename => "question_set_#{@question_set.id}.xls")
      }
    end
  end
  def to_xls question_set, name = "test"
    book = Spreadsheet::Workbook.new
    data = book.create_worksheet :name => name
    data.row(0).concat %w{序号 题干 选项1 选项2 选项3 选项4 正确选项 解释}
    header_format = Spreadsheet::Format.new :color => :green, :weight => :bold
    data.row(0).default_format = header_format
    all_questions = question_set.questions
    all_questions.each_with_index do |q,index|
      data.row(index + 1)[0] = index + 1
      data.row(index + 1)[1] = q.title
      data.row(index + 1)[2] = q.c1
      data.row(index + 1)[3] = q.c2
      data.row(index + 1)[4] = q.c3
      data.row(index + 1)[5] = q.c4
      data.row(index + 1)[6] = q.correct_index + 1
      data.row(index + 1)[7] = q.explanation
    end
    blob = StringIO.new('')
    book.write(blob)
    blob.string
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
