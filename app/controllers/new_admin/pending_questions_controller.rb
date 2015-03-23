# -*- encoding: utf-8 -*-

class NewAdmin::PendingQuestionsController < NewAdmin::ApplicationController
 # before_filter :require_admin, :only => [:index, :accept, :reject, :import]
  #layout "bootstrap"
  def index 
    cons = []
    cons.push("title like '%#{params[:title]}%'") if params[:title]
    cons.push(" state = 0 ") if params["status"].blank?
    cons.push(" state=2 ") if params["status"]=="reject"
    cons.push(" state=1 ") if params["status"]=="accept"
    @pending_questions = PendingQuestion.where(cons.join(" and ")).includes([:user]).order("id desc").page(params[:page])
  end

  def uploading
   
  end

  def edit
    @question = PendingQuestion.find params[:id]

  end

  def update
       @pending_question = PendingQuestion.find params[:id]
    if @pending_question.update_attributes(params["pending_question"])
      if @pending_question.state == 1
        create_question_from_pending_question @pending_question
        @question_set = QuestionSet.find(params["question_set_id"])
        keyword = @pending_question.keyword
        if keyword and !keyword.strip.empty?
          keyword_id = get_keyword_id keyword
          Contain.create(:question_id => @question.id, :keyword_id => keyword_id)
        end
        if @pending_question.save && @question.save
          @question.question_sets << @question_set
        end
      end
      respond_to do |format|
        format.html { redirect_to action: :index,notice: "通过成功" }
      end
    end

  end

  def list
    @accepted_questions = current_user.questions
    @rejected_questions = PendingQuestion.where("state = 2 AND user_id = ?", current_user.id)
    @pending_questions = PendingQuestion.where("state = 0 AND user_id = ?", current_user.id)
  end

  def new
    @pending_question = PendingQuestion.new
    if params[:modal]
      render :modal_new, :layout => false
    else
      redirect_to root_path
    end
  end

  def import

    begin
      sheet = Spreadsheet.open(params[:file].tempfile.path).worksheet(0)
    rescue
      redirect_to :action => 'index'
      flash[:notice] = "文件读取错误。请确认文件格式是否正确后再上传" 
      return nil
    end
    intend_for_set = params["pending_question"]["intended_for_set"]
    user_id = params["user_id"]
    sheet.each do |row|
      question = PendingQuestion.new
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
      question.intended_for_set = intend_for_set
      question.keyword = row[6]
      question.user_id = user_id || current_user.id
      question.correct_index = 1
      question.save
    end
    respond_to do |format|
      format.html { redirect_to :action => 'index' ,notice: "导入成功"}
    end

    
  end
  
  def create
    @pending_question = PendingQuestion.new(params[:pending_question])
    @pending_question.correct_index = 0
    @pending_question.intended_for_set = params[:intended_for_set]
    if user_signed_in?
      @pending_question.user_id = current_user.id
    end
    if @pending_question.save
      respond_to do |format|
        format.js { render :create }
      end
    end
  end

  def accept
    @pending_question = PendingQuestion.find(params[:id])
    @pending_question.state = '1'
    @pending_question.user_id=params["user_id"]
    create_question_from_pending_question(@pending_question)
    @question_set = QuestionSet.find(params["pending_question"][:question_set_id])
    keyword = params[:keyword]
    if keyword and !keyword.strip.empty?
      keyword_id = get_keyword_id keyword
      Contain.create(:question_id => @question.id, :keyword_id => keyword_id)
    end
    if @pending_question.save && @question.save
      @question.question_sets << @question_set
      respond_to do |format|
        format.js {render :js => "$('#action_row_#{@pending_question.id}').html('<td>#{t('pending_question.accepted')}</td><td><a target=_blank href=#{question_path(@question.token)}>#{t('pending_question.link')}</a></td>');"}
      end
    end
  end

  def batch_update
    ids = params["ids"].split(",")
    keywords = params["keywords"].split(",")
    user_ids = params["user_ids"].split(",")
    question_set_ids = params["question_set_ids"].split(",")
    length = ids.length
    length.times do |index|
      id = ids[index]
      keyword = keywords[index]
      user_id = user_ids[index]
      question_set_id = question_set_ids[index]
      pending_question = PendingQuestion.find(id)
      pending_question.state = '1'
      pending_question.keyword = keyword
      pending_question.user_id = user_id
      create_question_from_pending_question pending_question
      question_set = QuestionSet.find(pending_question.intended_for_set)
      if pending_question.keyword and !keyword.strip.empty?
        keyword_id = get_keyword_id keyword
        Contain.create(:question_id => @question.id, :keyword_id => keyword_id)
      end
      if pending_question.save && @question.save
        @question.question_sets << question_set
      end
    end
    render :text=>"ok"
  end

  def reject
    @pending_question = PendingQuestion.find(params[:id])
    @pending_question.state = '2'
    @pending_question.comment = params[:comment]
    if @pending_question.save
      respond_to do |format|
        format.js {render :js => "$('#action_row_#{@pending_question.id}').html('<td>#{t('pending_question.rejected')}</td>');"}
      end
    end
  end

  private

  def get_keyword_id(keyword)
    keywords= {}
    keyword.strip!
    if !(keyword_id = keywords[keyword]).nil?
      keyword_id
    elsif !(Keyword.where(:name => keyword).first).nil?
      keywords[keyword] = Keyword.where(:name => keyword).first.id
    else
      Keyword.create(:name => keyword).id
    end
  end
end
