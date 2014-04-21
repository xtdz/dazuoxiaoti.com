# -*- encoding: utf-8 -*-
module ApplicationHelper
  extend ActiveSupport::Memoizable

  def user_correct_count
    if user_signed_in?
      current_participation ? current_participation.correct_count : 0
    else
      session[:correct_count] ? session[:correct_count] : 0
    end
  end

  def user_quota
    if user_signed_in?
      current_user.answer_quota
    else
      10
    end
  end

  def get_item_count_and_unit(project)
    return "" if project.id==12
    return YixinCard.where("user_id is not null").count.to_s+"张" if project.id==14
    return project.item_count.to_s + project.benefit.unit.to_s
  end

  def user_contribution
    if user_signed_in?
      current_participation ? current_participation.contribution : 0
    else
      session[:correct_count] ? session[:correct_count] : 0
    end
  end

  def total_participation_count
    total = 0
    Project.all.each do |p|
      total = total + p.participation_count
    end
    total
  end

  def total_correct_count
    total = 0
    Project.all.each do |p|
      total = total + p.correct_count
    end
    total
  end

  def total_items_count
    total = 0
    Project.all.each do |p|
      total = total + p.correct_count/p.rate
    end
    total
  end

  def project_image_path(project, type)
    case type
    when :main
      if project.upload_image_main?
        project.upload_image_main.url
      else
        asset_path(project.image_path :main)
      end
    when :about
      if project.upload_image_about?
        project.upload_image_about.url
      else
        asset_path(project.image_path :about)
      end
    when :sina_poster
      if project.upload_image_share_question1?
        project.upload_image_share_question1.url
      else
        asset_path(project.image_path :sina_poster)
      end
    when :renren_poster
      if project.upload_image_share_question1?
        project.upload_image_share_question1.url
      else
        asset_path(project.image_path :renren_poster)
      end
    when :qq_poster
      if project.upload_image_share_question1?
        project.upload_image_share_question1.url
      else
        asset_path(project.image_path :qq_poster)
      end
    end
  end

  def organization_image_path organization
    if organization.upload_image?
      organization.upload_image.url
    else
      asset_path organization.image_path
    end
  end

  def benefit_image_path benefit
    if benefit.upload_image?
      benefit.upload_image.url
    else
      asset_path benefit.image_path
    end
  end

  def question_set_image_path question_set
    if question_set.upload_image?
      question_set.upload_image.url
    else
      asset_path question_set.image_path
    end
  end

  private
  def current_project
    @project
  end

  def current_participation
    Participation.user(current_user.id).project(@project.id).first
  end

  def current_contribution
    if current_participation
      current_participation.contribution
    else
      0
    end
  end

  memoize :current_participation
end
