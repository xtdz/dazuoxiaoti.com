class AnswerRecord < ActiveRecord::Base
	belongs_to :user
	after_save :judge_answer_count

	def judge_answer_count
	   if correct_count !=0 && correct_count/20>0 && correct_count%20==0
	   	 card = YixinCard.unused_card
	   	 return unless card
	   	 card.user_id=user_id
	   	 card.save
	   end
	end
end
