class PendingQuestion < ActiveRecord::Base
  validates_presence_of :title, :c1, :c2, :c3, :c4, :correct_index
  belongs_to :user

  after_save :send_message 

  def choices
    [c1, c2, c3, c4]
  end

  def correct_answer
    choices[correct_index]
  end
  
  def wrong_answers
    answers = choices
    answers.delete(correct_answer)
    return answers
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
  
  private
  def send_message

    return unless state_changed?
    content = ""
    #content = "亲爱的#{user.try(:nickname)}：恭喜你！你于#{created_at.year}年#{created_at.month}月#{created_at.day}日所出的题目“#{title}”已经审核通过~感谢您的参与，欢迎再接再厉，让小题的题库爆满吧！" if state==1
    #content = "亲爱的#{user.try(:nickname)}：非常遗憾，你于#{created_at.year}年#{created_at.month}月#{created_at.day}日所出的题目“#{title}”没有通过审核，原因是：#{comment}。虽然没能通过，但是仍然感谢您的参与，请继续加油哦！" if state==2
    #title = "【出题通知】"

    #Message.send_message(-1,user_id,{"title"=>title,"content"=>content,"topic"=>"系统邮件"}) if content.present?



  end

end
