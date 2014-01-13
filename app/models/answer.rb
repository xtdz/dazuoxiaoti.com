class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates_presence_of :state, :user, :question
  #after_create :analy_answer_for_card

  def analy_answer_for_card
    if user_id.present? && correct?
       answer = AnswerRecord.find_or_initialize_by_user_id user_id
       answer.answer_at = answer.answer_at || created_at
       answer.increment!(:correct_count)
     # user.answer_record.find_or_initialize_by
    end
  end

  def incorrect?
    state == 0
  end

  def correct?
    state == 1
  end

  def skipped?
    state == 2
  end

  def correct= is_correct
    self.state = is_correct ? 1 : 0
  end

  def counter_name
    if skipped?
      :skipped_count
    elsif correct?
      :correct_count
    else
      :incorrect_count
    end
  end

  def serialize
    {
      :question_id => question_id,
      :state => state,
      :choice => choice
    }
  end

end
