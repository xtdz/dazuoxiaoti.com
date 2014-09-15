class CommonData < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sharable , :polymorphic => true
  belongs_to :coordinator, :class_name => 'Organization'
  belongs_to :sponsor, :class_name => 'Organization'
  belongs_to :benefit
  has_many :participations
  has_many :weibos
  has_many :updates
  has_many :users, :through => :participations
  
  accepts_nested_attributes_for :benefit, :sponsor, :coordinator
  default_scope :order => 'id ASC'
  validates_presence_of :benefit, :coordinator, :sponsor, :rate, :limit

  has_attached_file :upload_image_main
  has_attached_file :upload_image_about
  has_attached_file :upload_image_small
  has_attached_file :upload_image_banner

  has_attached_file :upload_image_share_question1
  has_attached_file :upload_image_share_question2
  has_attached_file :upload_image_share_finish1
  has_attached_file :upload_image_share_finish2

  validates_attachment_content_type :upload_image_share_finish2,:upload_image_share_finish1,
                                    :upload_image_share_question2,:upload_image_share_question1,
                                    :upload_image_banner,:upload_image_small,:upload_image_about,
                                    :upload_image_main, :content_type => ["image/jpg", "image/jpeg", "image/png"]
end
