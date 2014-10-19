# -*- encoding: utf-8 -*-

class PendingQuestionsController < ApplicationController
 # before_filter :require_admin, :only => [:index, :accept, :reject, :import]
  layout "bootstrap"
  def index 
    @pending_questions = PendingQuestion.where("state = 0")
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
      sheet = ::Spreadsheet.open(params[:file].tempfile.path).worksheet(0)
    rescue
      redirect_to :action => 'index'
      flash[:notice] = "文件读取错误。请确认文件格式是否正确后再上传" 
      return nil
    end
    @new_questions = []
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
      question.keyword = row[6]
      question.user_id = current_user.id
      question.correct_index = 1
      question.save
      @new_questions.push question
      flash[:notice] = "导入成功"
    end
    @pending_questions = @new_questions
    respond_to do |format|
      format.html { render :action => 'index' }
    end
  end
  
  def create
    @pending_question = PendingQuestion.new(params[:pending_question])
    @pending_question.correct_index = 0
   # @pending_question.intended_for_set = params[:intended_for_set]
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
    create_question_from_pending_question(@pending_question)
    @question_set = QuestionSet.find(params[:question_set_id])
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
