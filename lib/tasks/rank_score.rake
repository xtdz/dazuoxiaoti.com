namespace :weijuan do
	desc "cal rank score"
	task :cal_rank_score => :environment do
         User.all.each do |user|       	
            user.set_question_num = user.questions.count        
            user.save!
            puts user.rank_score
         end
	end
	desc 'question trace'
	task :trace_question => :environment do
		(1..300).to_a.each do |i|
           Answer.order("id").offset((i-1)*10000).limit(10000).each do |answer|
            begin 
        	  question = answer.question
        	  QuestionTrace.record_answer(question,question.choices.index(answer.choice),answer.correct?)
        	rescue
               next
        	end
           end
        end
	end
end