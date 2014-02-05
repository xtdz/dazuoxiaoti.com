require "digest/sha1"

class Question < ActiveRecord::Base
  validates_presence_of :title, :c1, :c2,:c3,:c4,:correct_index
  belongs_to :category
  belongs_to :source
  belongs_to :user
  has_one :question_trace
  belongs_to :sponsor, :class_name => "Organization", :foreign_key => "sponsor_id"
  has_many :answers, :dependent => :destroy
  has_many :contains, :dependent => :destroy
  has_many :keywords, :through => :contains
  has_many :taggeds, :dependent => :destroy
  has_many :tags, :through => :taggeds
  has_many :feedbacks, :dependent => :destroy
  has_and_belongs_to_many :question_sets
  #TODO: Removed Tagged
  scope :tagged, lambda {|tag| joins(:tags).where(:tags => {:name => tag})}
  scope :featured, lambda { tagged('featured') }

  scope :for_user, lambda {|user_id|
    joins("LEFT OUTER JOIN " +
      "(SELECT question_id FROM answers WHERE user_id = #{user_id} and state > 0) " +
      "answers ON questions.id = answers.question_id"
    ).where('answers.question_id IS NULL')
  }

  scope :by_sponsor, lambda { |sponsor_id| where(:sponsor_id => sponsor_id) }

  scope :random, lambda { (c = count) > 0 ? offset(rand(c)).limit(1) : limit(0) }

  scope :from_set, lambda {|question_set_id| joins(:question_sets).where(:question_sets => {:id => question_set_id})}

  scope :not_in, lambda { |ids| (ids && !ids.empty?) ? where(['questions.id NOT IN (?)', ids]) : where('questions.id NOT IN (0)') }

  after_create :generate_token,:set_user_question_num

  def set_user_question_num
    if self.user
      self.user.set_question_num = self.user.set_question_num+1
      self.user.save
    end 
  end

  def find_by_token token
    if token && token.to_s.length == 40
      Question.where(:totken => token).first
    else
      nil
    end
  end
  
  def self.random_question question_set_id=nil, ids = []
    if question_set_id && !question_set_id.empty?
      question = self.from_set(question_set_id).not_in(ids).random.first
    else
      question = self.from_set(20).not_in(ids).random.first
    end

    if question.nil?
      self.not_in(ids).random.first
    else
      question
    end
  end

  def choices
    [c1, c2, c3, c4]
  end

  def choice_count(choice)
    answers.where("choice = ?", choice).count
  end

  def correct_answer
    choices[correct_index]
  end

  def wrong_answers
    answers = choices
    answers.delete(correct_answer)
    return answers
  end

  def correct_rate
    if answers.where("state = 0 OR state = 1").count != 0
        "%.2f" % (answers.where("state = 1").count * 100.0 / answers.where(:state => [0, 1]).count)
    else
      0.00
    end
  end

  def shuffle
    choice = choices[correct_index]
    answers = choices.sort_by {rand}
    self.correct_index = answers.index(choice)
    self.c1 = answers[0]
    self.c2 = answers[1]
    self.c3 = answers[2]
    self.c4 = answers[3]
    save
  end

  def self.search(search)
    search.blank? ? [] : all(:conditions => ['title LIKE ?', "%#{search.strip}%"])
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest(SALT +  id.to_s)
    save
  end

  def is_sponsored?
    return (sponsor_id > 0)
  end

  def get_source
    if is_sponsored?
      name = sponsor.name
      description = I18n.t("question.source.sponsor") + sponsor.name
      link = sponsor.url
      image_path = sponsor.image_path
      upload_image_path = sponsor.upload_image? ? sponsor.upload_image.url : nil
    elsif source
      name = source.name
      description = source.description
      link = source.url
      image_path = source.image_path
      upload_image_path = nil
    elsif user
      name = user.nickname
      description = I18n.t(user.type)
      link = (user.authentication) ? user.authentication.user_link : 'http://weibo.com/dazuoxiaoti'
      image_path = 'static/auth/default.jpg'
      upload_image_path = nil
    else # from xiaotidazuo
      name = I18n.t("question.source.xiaotidazuo")
      description = I18n.t("question.source.xiaotidazuo_des")
      link = 'http://weibo.com/dazuoxiaoti'
      image_path = 'static/header/logo_text.png'
      upload_image_path = nil
    end
     {"name" => name, "description" => description, "link" => link, "image_path" => image_path, "upload_image_path" => upload_image_path}
  end

  def valid_answer? answer
    !answer.nil? and choices.include? answer.choice
  end

  private
  SALT = "2d24c0de7cc1e41104dd06558ba5d75366b34e1e"
end
