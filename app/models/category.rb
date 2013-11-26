# -*- encoding: utf-8 -*-
class Category < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :uniqueness => true
  #has_many :questions
  has_many :question_sets

  scope :shown, where(:is_show => true)

  has_attached_file :icon, :styles => { :medium => "300x300", :thumb => "50x40" },:url => "/categories/:id_partition/:style/:filename"

 
 
end
