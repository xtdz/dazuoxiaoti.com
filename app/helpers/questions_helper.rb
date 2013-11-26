module QuestionsHelper
  def tsina_question_path token, project, referer, page, question_set
    if page == "question"
      from = :snq
    elsif page == "solution"
      from = :sns
    end
    question_set_id = question_set.nil? ? nil : question_set.id
    sns_question_path token, project, referer, from, question_set_id
  end

  private
  def sns_question_path token, project, referer, from, question_set_id
    if referer
      question_path token, :project_id => project.id, :referer_id => referer.id, :in => from, :question_set => question_set_id
    else
      question_path token, :project_id => project.id, :in => from, :question_set => question_set_id
    end
  end
end
