module MobileHelper
  def select_total_ratio_str c
    sel = @user_question_sets.reduce(0) {|sum, t| t.category_id == c.id ? sum + 1 : sum}
    tot = QuestionSet.all.reduce(0) {|sum, t| t.category_id == c.id ? sum + 1 : sum}
    "(<span class='select_count'>#{sel}</span>/#{tot})".html_safe
  end
end
