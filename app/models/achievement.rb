class Achievement < ActiveRecord::Base

  def image_path
    "achievements/#{label}.png"
  end

  def self.trigger(achievement_label, user, options = {})
    achievement = get_achievement(achievement_label, options)
    if achievement and !user.awarded?(achievement)
      begin
        eligible = self.send("verify_#{achievement_label}", user, options)
      rescue
        eligible = false
      end
      if eligible
        user.award achievement
      end
    end
  end

  def self.get_achievement(label, options = {})
    case label
      when nil
        achievement = nil
      when :participation
        achievement = options[:project].nil? ? nil : get_achievement_by_label("participation_#{options[:project].id}")
      when :completion
        achievement = options[:project].nil? ? nil : get_achievement_by_label("completion_#{options[:project].id}")
      else
        achievement = get_achievement_by_label(label)
    end
  end

  def self.get_achievement_by_label(label)
    achievement = Achievement.where(:label => label).first
    if achievement
      achievement
    else
      achievement = Achievement.create(:label => label)
    end
  end

  def self.verify_participation(user, options = {})
    participation = Participation.user(user.id).project(options[:project].id).first
    participation && participation.correct_count >= 1
  end

  def self.verify_completion(user, options = {})
    participation = Participation.user(user.id).project(options[:project].id).first
    if participation.nil?
      false
    else
      participation.correct_count >= options[:project].rate
    end
  end
end
