# coding: utf-8
class Project < ActiveRecord::Base
  belongs_to :coordinator, :class_name => 'Organization'
  belongs_to :sponsor, :class_name => 'Organization'
 
  belongs_to :benefit
  has_many :participations
  has_many :weibos
  has_many :updates
  has_many :users, :through => :participations

  #attr_accessible :rate, :limit, :coordinator, :benefit, :sponsor

  validates_presence_of :benefit, :coordinator, :sponsor, :rate, :limit

  has_attached_file :upload_image_main

  has_attached_file :upload_image_about

  def item_count
    correct_count / rate
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
    end_time < Time.now || item_count >= limit
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

  private
  def send_counter_message counter
    if counter == :participation_count
      Project.send_status_message "{participation:#{participation_count}}"
    elsif counter == :correct_count
      Project.send_status_message "{correct:#{correct_count},item:#{correct_count/rate}}"
    end
  end

  def self.connected_bunny
    @bunny ||= Bunny.new
    if !@bunny.connected?
      @bunny.start
    end
    @bunny
  end

  def self.exchange
    if @exchange.nil? || @exchange.client.nil? || !@exchange.client.connected?
      @exchange = connected_bunny.exchange('xtdz.status', :type => :fanout)
    else
      @exchange
    end
  end

  def self.send_status_message msg
    exchange.publish(msg)
  end
end
