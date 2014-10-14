class UpdateQuestionTraceWithAnswers < ActiveRecord::Migration
  def change
  	question_trace = QuestionTrace.all
  	question_trace.each do |qt|
  		question = Question.where("id = ?",qt.question_id).first
  		if !question.nil?
  			qt.skip_num = Answer.where("question_id = ? and state = ?",question.id,2).count
  			qt.c1_click_num = Answer.where("question_id = ? and choice = ?",question.id,question.c1).count
  			qt.c2_click_num = Answer.where("question_id = ? and choice = ?",question.id,question.c2).count
  			qt.c3_click_num = Answer.where("question_id = ? and choice = ?",question.id,question.c3).count
  			qt.c4_click_num = Answer.where("question_id = ? and choice = ?",question.id,question.c4).count
  			case question.correct_index
  			when 0
  				qt.corrent_num = qt.c1_click_num
  			when 1
  				qt.corrent_num = qt.c2_click_num
  			when 2
  				qt.corrent_num = qt.c3_click_num
  			when 3
  				qt.corrent_num = qt.c4_click_num
  			end
  			qt.total_num = qt.c1_click_num + qt.c2_click_num + qt.c3_click_num + qt.c4_click_num
  			qt.save
  		end
  	end
  end
end
