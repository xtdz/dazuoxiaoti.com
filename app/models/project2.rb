class Project2 < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :common_data, :as => :sharable
  has_many :participations
  has_many :weibos
  has_many :updates
  has_many :users, :through => :participations
  default_scope :order => 'id ASC'
  validates_presence_of :common_data

  def build_nested_models
    build_common_data unless common_data
    common_data.build_sponsor unless common_data.sponsor
    common_data.build_coordinator unless common_data.coordinator
  end

  def increment(counter)
    super(counter)
    if persisted?
      common_data.class.increment_counter(counter, common_data.id)
      #send_counter_message  counter
    end
  end

  def expired?
    if common_data.end_time
      common_data.end_time < Time.now
    else
      false
    end
  end


  def self.find_all_ongoing
    Project2.joins(:common_data).where(["common_data.end_time > ? and not common_data.hidden",Time.now])
  end

  def self.find_all_expired
    Project2.joins(:common_data).where(["common_data.end_time < ? and not common_data.hidden", Time.now])
  end

  def image_path type
    case type.to_sym
    when :main
      "project2s/#{id}/main.jpg"
    when :about
      "project2s/#{id}/about.jpg"
    when :project
      "project2s/#{id}/project.png"
    when :sina_poster
      "project2s/#{id}/poster_1.jpg"
    when :renren_poster
      "project2s/#{id}/poster_1.jpg"
    when :qq_poster
      "project2s/#{id}/poster_1.jpg"
    when :small
      "project2s/#{id}/small.jpg"
    else
      ""
    end
  end

  def isProject2?
    true
  end

  def progress_bar_path
    'questions/project2_progress_bar'
  end
  
  def tab_path page
    case page.to_sym
    when :on_question_page
      'project2s/tab_on_question_page'
    else
      'project2s/tab_on_project_page'
    end
  end

  def block_path
    "project2s/project2_block"
  end

  def feedback_image_path index
    "project2s/#{id}/feedback#{index}.jpg"
  end

  def progress_path user_correct_count
    common_data.benefit.progress_path user_correct_count, common_data.rate
  end
  
end
