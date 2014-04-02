require 'nokogiri'
class StaticController < ApplicationController
  before_filter :reset_current_url_to_root, :only => [:about_us, :faq, :contact, :thanks]
  before_filter :require_admin, :only => [:admin]
  before_filter :check_mobile
  layout "index"

  def about_us
  end

  def faq
  end

  def contact
  end

  def thanks
  end

  def donate
  end

  def home
    @pics = Asset.order("is_top,id desc")
    @notices = HomeNotice.order("is_top,id desc")
    @question_sets = QuestionSet.where(:is_hot => true).all
    @question_sets.concat(
      QuestionSet.order('RAND()').limit([6, @question_sets.size].max - @question_sets.size)
    )
    kind= params[:v].to_i==1 ? 2 : 1
    @projects = Project.find_ongoing(kind).reverse
    projects_count = @projects.count>5 ? 5 : @projects.count
    @past_projects = Project.find_expired(kind).reverse.first(5 - projects_count)
    @default_project = @projects.first

    #FOR BEIJING 4ZHONG
    if current_user && current_user.email.match("sizhong.com")
      redirect_to "/projects/5"
    end
  end

  def admin
    @projects = Project.all
  end

  def share
    if params[:modal]
      render :modal_share, :layout => false
    else
      redirect_to root_path
    end
  end

  def guide
    if params[:modal]
      render :modal_guide, :layout => false
    else
      redirect_to root_path
    end
  end

  def close_notice
    @id = params[:id].to_i
    if current_user.notice == @id
      current_user.notice = @id + 1
      current_user.save
    end
    respond_to do |format|
      format.js {render :js => "$('.new_function#nf_#{@id.to_s}').hide()"}
    end
  end

  def sizhong
    @correct_count = User.where("email Like '%sizhong%'").sum("correct_count")
  end

  def fuzhong
    sign_in (User.where(:id=>49935).first || User.first)
    @projects = [(Project.find 16)]

  end
  
  def diandian
    doc = Nokogiri::XML(open 'http://xiaotidazuoweigongyi.diandian.com/rss')
    @posts = {}
    doc.css('item').each do |post|
      @posts[post.css('title')[0].content] = post.css('link')[0].content
    end
    respond_to do |format|
      format.json { render :json => @posts.to_json}
    end
  end
  def check_mobile
    if from_mobile? && mobile_admin?
      redirect_to '/mobile/home'
    end
  end
end
