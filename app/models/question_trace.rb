class QuestionTrace < ActiveRecord::Base
	belongs_to :question

	def self.record_answer(question,answer_index=nil,is_correct=true)
        trace = self.find_or_initialize_by_question_id question.id
		if answer_index.nil?
			trace.skip_num = trace.skip_num+1
        else
        	trace.send("c#{answer_index+1}_click_num=",trace.send("c#{answer_index+1}_click_num")+1)
        	trace.total_num=trace.total_num+1
        	trace.corrent_num=trace.corrent_num+1 if is_correct
		end
		trace.save
	end
end
