# coding: utf-8
class Project < ActiveRecord::Base
  belongs_to :coordinator, :class_name => 'Organization'
  belongs_to :sponsor, :class_name => 'Organization'
  belongs_to :benefit
  has_many :participations
  has_many :weibos
  has_many :updates
  has_many :users, :through => :participations

  accepts_nested_attributes_for :benefit, :sponsor, :coordinator

  validates_presence_of :benefit, :coordinator, :sponsor, :rate, :limit

  has_attached_file :upload_image_main
  has_attached_file :upload_image_about
  has_attached_file :upload_image_small
  has_attached_file :upload_image_banner
  has_attached_file :upload_image_customed

  has_attached_file :upload_image_share_question1
  has_attached_file :upload_image_share_question2
  has_attached_file :upload_image_share_finish1
  has_attached_file :upload_image_share_finish2

  def build_nested_models
    build_benefit unless benefit
    build_sponsor unless sponsor
    build_coordinator unless coordinator
  end

  def item_count
    (correct_count / rate ) * unit_rate
  end

  def assister(oid)
    Organization.where(:id=>oid).first
  end
  def increment(counter)
    super(counter)
    if persisted?
      self.class.increment_counter(counter, id)
      #send_counter_message  counter
    end
  end

  def expired?
    if end_time
      end_time < Time.now || item_count >= limit
    else
      false
    end
  end


  def self.find_all_ongoing
    Project.where(["end_time > ? and `limit` > correct_count/rate and not hidden",Time.now])
  end

  def self.find_all_expired
    Project.where(["(`limit` <= correct_count/rate or end_time < ? and not hidden)", Time.now])
  end

  def self.find_ongoing(kind=1)
    Project.where(["project_kind=? and end_time > ? and `limit` > correct_count/rate and not hidden",kind,Time.now])
  end

  def self.find_expired(kind=1)
    Project.where(["project_kind=? and (`limit` <= correct_count/rate or end_time < ? and not hidden)", kind,Time.now])
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
    else
      ""
    end
  end

  def feedback_image_path index
    "projects/#{id}/feedback#{index}.jpg"
  end

  def progress_path user_correct_count
    benefit.progress_path user_correct_count, rate
  end

  def equation
    return "答题支持大爱清尘" if project_kind==2
    @equestion ||= "#{rate}#{I18n.t 'question.equation'}1#{benefit.unit}#{benefit.short_name}"
  end
end
