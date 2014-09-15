# encoding: utf-8
module ShareHelper
  def share_question_message question, project
    message = "【这题有意思】"
    message += "#{question.title}"
    message += " [a]#{question.choices[0]}"
    message += " [b]#{question.choices[1]}"
    message += " [c]#{question.choices[2]}"
    message += " [d]#{question.choices[3]}, "
    if project.id == 25 
      message = "#福特 更美好的世界# " + message + project.common_data.share_question_text
    elsif project.id < 12 or project.common_data.share_question_text.nil?
      message += "一起来趣味答题捐#{@project.common_data.benefit.short_name}"
    else
      message += project.common_data.share_question_text
    end
    message
  end

  def share_correct_count_for_donation_projects correct_count, project
    message = "【趣味微公益】最近在“小题大作”网站参与"
    message += "“#{project.name}”"
    message += "答题捐赠项目，"
    message += "累计答对#{correct_count}题。"
    if project.id < 12 or project.common_data.share_question_text.nil?
      message += "一[din推撞]个人[围观]的力量有限，快来帮帮我吧"
    else
      message += project.common_data.share_finish_text
    end
    message
  end
end
