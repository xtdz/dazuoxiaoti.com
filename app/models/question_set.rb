class QuestionSet < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, :through => :subscriptions
  has_many :question_traces,:through =>:questions
  belongs_to :category
  has_and_belongs_to_many :questions
  validates :name,:category_id,:presence => true
  validates :upload_image,:presence => true,:on=>"create"
  validates :name, :uniqueness => true

  default_scope order("id desc")


  has_attached_file :upload_image

  def image_path
    if image_name
      "question_sets/#{image_name}"
    end
  end
end
