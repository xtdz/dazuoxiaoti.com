class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :referer, :class_name => 'User'

  %w(user project referer).each do |name|
    scope name, lambda {|id| where("#{name}_id" => id)}
  end

  scope :recents, lambda {order('updated_at DESC')}

  def ranking
    if contribution_rank
      @ranking ||= contribution_rank
    else
      @ranking ||= project.participation_count
    end
  end

  def increment(counter)
    super(counter)
    if persisted?
      if counter == :contribution
        self.class.increment_counter(counter, id)
      else
        save
      end
    end
  end

  def increment_counter counter
    increment counter
    if counter == :correct_count && referer_id
      increment_referer_contribution
    end
  end

  def increment_referer_contribution
    referer_participation.increment_contribution
  end

  def increment_contribution
    increment :contribution
    User.increment_counter :contribution, user_id
  end


  def self.get_participation user, project, referer = nil
    participation = Participation.user(user.id).project(project.id).first
    if participation.nil?
      project.increment :participation_count
      participation = Participation.create :user => user, :project => project, :referer => referer
    else
      participation
    end
  end


  def self.get_participation_by_id user_id, project_id, referer_id = nil
    participation = Participation.user(user_id).project(project_id).first
    @project = Project.find(project_id)
    if participation.nil?
      @proejct.increment :participation_count
      participation = Participation.create :user_id => user_id, :project_id => project_id, :referer_id => referer_id
    else
      participation
    end
  end

  def last_update
    diff = (Time.now - updated_at).to_i
    if diff < 60
      diff.to_s + I18n.t('time.seconds_ago')
    elsif diff < 3600
      (diff/60).to_s + I18n.t('time.minutes_ago')
    elsif diff < 86400
      (diff/3600).to_s + I18n.t('time.hours_ago')
    else
      (diff/86400).to_s + I18n.t('time.days_ago')
    end
  end

  private
  def referer_participation
    @referer_participation ||= Participation.get_participation_by_id referer_id, project_id
  end
end
