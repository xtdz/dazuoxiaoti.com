class PendingQuestion < ActiveRecord::Base
  validates_presence_of :title, :c1, :c2, :c3, :c4, :correct_index
  belongs_to :user

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

end
