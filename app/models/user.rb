require 'helpers/models/user/authenticatable'
require 'helpers/models/user/achiever'

class User < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  include Helpers::User::Authenticatable
  include Helpers::User::Achiever

  validates :nickname, :presence => true, :length => {:maximum => 20}
  attr_accessible :name, :nickname

  has_many :answers, :dependent => :destroy
  has_many :participations, :dependent => :destroy
  has_many :projects, :through => :participations
  has_many :feedbacks
  has_many :pending_questions
  has_many :questions
  has_many :subscriptions
  has_many :question_sets, :through => :subscriptions
  has_many :users_messages
  has_many :unread_messages,:class_name=>"UsersMessage",:conditions=>{:is_read=>false}
  has_many :messages,:through=>:users_messages,:order=>"is_read,id desc"
  has_one :answer_record
  has_many :yixin_cards
  after_create :add_question_sets
  before_save :cal_rank_score
  #TODO rank score is integer.
  def cal_rank_score
     self.rank_score = self.correct_count.to_i * 1 + self.contribution.to_i * 1.5 + self.set_question_num.to_i * 2  #if correct_count_changed? || contribution_changed? || set_question_num_changed?
  end

  def type
    if authentication.nil?
      :'user.type.dazuoxiaoti'
    else
      authentication.user_type
    end
  end

  def rank
    count = User.count
    more_rank = User.count(:conditions=>"rank_score>#{self.rank_score}")
    [more_rank,count]
  end

  def answered_count
    incorrect_count + correct_count
  end

  def answer_limit
    correct_count + answer_quota
  end

  def increment(counter, from_mobile = false)
    if counter == :correct_count && !from_mobile
          update_counters(:correct_count => 1, :answer_quota => -1)
    else
      update_counters(counter => 1)
    end
  end

  def add_answer_for_project(answer, project, referer = nil, from_mobile = false)
    if valid_answer?(answer) and valid_project?(project)
      answers << answer
      increment_counter project, answer.counter_name, referer, from_mobile
      if answer.counter_name == :correct_count
        Achievement.trigger(:participation, self, :project => project)
        Achievement.trigger(:completion, self, :project => project)
      end
    end
  end


  def add_answers_for_project(answers, project, referer = nil)
    if valid_project?(project)
      counters = {:incorrect_count => 0, :correct_count => 0, :skipped_count => 0}
      answers.each do |ans|
        if valid_answer? ans
          self.answers << ans
          counters[ans.counter_name] += 1
        end
      end
      if counters.values.inject {|sum, val| sum + val} > 0
        update_counters counters
      end
      if counters[:correct_count] > 0
        p = participations.build :project => project, :referer => referer
        p.update_attributes counters
      end
    end
  end

  def get_next_question question_set_id=nil
    if question_set_id
      Question.from_set(question_set_id).for_user(id).shuffle.first
    else
      question_sets.shuffle.each do |set|
        unless (question = set.questions.for_user(id).shuffle.first).nil?
          return question
        end
      end
      return nil
    end
  end

  def get_next_sponsor_question(sponsor_id)
  	question_count = Question.by_sponsor(sponsor_id).for_user(self.id).count
    Question.by_sponsor(sponsor_id).for_user(self.id).random(question_count).first
  end

  def get_next_project_question(project_id)
    question_count = Question.by_project(project_id).for_user(self.id).count
    Question.by_project(project_id).for_user(self.id).random(question_count).first
  end

  def feedback_for_question question
    feedback = feedbacks.where(:question_id => question.id).first
    if feedback.nil?
      feedback = Feedback.create :user => self, :question => question
    else
      feedback
    end
  end

  def project_participation project_id
    Participation.user(id).project(project_id).first
  end

  def project_contribution project_id
    if (participation = project_participation project_id)
      participation.contribution
    else
      0
    end
  end

  def most_recent_project
    projects.where(['end_time > ?', Time.now]).order('participations.updated_at DESC').limit(1).first
  end

  def recent_participations
    participations.recents.includes(:project).limit(3)
  end

  def recent_sets
    question_sets.order('subscriptions.created_at DESC')
  end

  memoize :project_participation

  private
  def valid_answer?(answer)
    !answer.nil? and valid_question? answer.question
  end

  def valid_question?(question)
    if question.nil?
      false
    else
      !self.answers.where(:question_id => question.id, :state => 1).exists?
    end
  end

  def valid_project?(project)
    !project.nil? and project.persisted?
  end

  def update_counters(counters = {})
    counters.each do |counter, count|
      self[counter] ||= 0
      self[counter] += count
    end
    if persisted?
      self.class.update_counters(id, counters)
    end
  end

  def increment_counter project, counter, referer = nil, from_mobile = false
      participation = Participation.get_participation(self, project, referer)
      increment(counter,from_mobile)
      project.increment counter
      participation.increment_counter counter
  end

  def add_question_sets
    QuestionSet.where('id < 10').all.each do |question_set|
      question_sets << question_set
    end
  end
end
