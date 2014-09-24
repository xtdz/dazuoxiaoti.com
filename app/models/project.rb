# coding: utf-8
class Project < ActiveRecord::Base
  has_one :common_data, :as => :sharable
  belongs_to :benefit
  has_many :participations
  has_many :weibos
  has_many :updates
  has_many :users, :through => :participations
  default_scope :order => 'id ASC'
  validates_presence_of :common_data,:benefit,:rate,:unit_rate,:limit
  def build_nested_models
    build_common_data unless common_data
    build_benefit unless benefit
    common_data.build_sponsor unless common_data.sponsor
    common_data.build_coordinator unless common_data.coordinator
  end

  def item_count
    (common_data.correct_count / rate) * unit_rate
  end

  def assister(oid)
    Organization.where(:id=>oid).first
  end
  def increment(counter)
    super(counter)
    if persisted?
      common_data.class.increment_counter(counter, id)
      #send_counter_message  counter
    end
  end

  def expired?
    if common_data.end_time
      common_data.end_time < Time.now || item_count >= limit
    else
      false
    end
  end


  def self.find_all_ongoing
    Project.joins(:common_data).where(["common_data.end_time > ? and `limit` > ((common_data.correct_count/rate)*unit_rate) and not common_data.hidden",Time.now])
  end

  def self.find_all_expired
    Project.joins(:common_data).where(["(`limit` <= ((common_data.correct_count/rate)*unit_rate) or common_data.end_time < ? and not common_data.hidden)", Time.now])
  end

  def image_path type
    case type.to_sym
    when :main
      "projects/#{id}/main.jpg"
    when :about
      "projects/#{id}/about.jpg"
    when :project
      "projects/#{id}/project.png"
    when :sina_poster
      "projects/#{id}/poster_1.jpg"
    when :renren_poster
      "projects/#{id}/poster_1.jpg"
    when :qq_poster
      "projects/#{id}/poster_1.jpg"
    when :small
      "projects/#{id}/small.jpg"
    else
      ""
    end
  end

  def isProject2
    false
  end
  
  def progress_bar_path
    'questions/project_progress_bar'
  end
  
  def tab_path page
    'projects/tab'
  end

  def block_path
    "projects/project_block"
  end

  def feedback_image_path index
    "projects/#{id}/feedback#{index}.jpg"
  end

  def progress_path user_correct_count
    benefit.progress_path user_correct_count, rate
  end

  def equation
    @equestion ||= "#{rate}#{I18n.t 'question.equation'}#{unit_rate}#{benefit.unit}#{benefit.name}"
  end

end
