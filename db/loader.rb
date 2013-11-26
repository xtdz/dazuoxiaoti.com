#encoding: utf-8
def load_questions(file)
  f = open(file)
  f.each do |line|
    arr = line.split(",").map {|value| value.strip}
    question = create_question(arr)
  end
end

def create_question(arr)
  explanation = arr[5] || ""
  if arr[6]
    category_id = 0
    sponsor_id = 0
  else
    category_id = 0
    sponsor_id = 3
  end

  question = Question.new :title => arr[0], :c1 => arr[1], :c2 => arr[2], :c3 => arr[3], :c4 => arr[4], :correct_index => 0, :explanation => explanation, :category_id => 0, :sponsor_id => sponsor_id
  question.shuffle

  [arr[7], arr[8]].each do |keyword|
    if keyword and !keyword.strip.empty?
      keyword_id = get_keyword_id keyword
      Contain.create(:question_id => question.id, :keyword_id => keyword_id)
    end
  end
end


@question_sets = {}
def get_question_set(question_set_name)
  question_set_name.strip!
  if !(question_set = @question_sets[question_set_name]).nil?
    question_set
  elsif !(question_set = QuestionSet.where(:name => question_set_name).first).nil?
    @question_sets[cat] = QuestionSet.where(:name => question_set_name).first.id
  else
    raise 'Wrong Category' + question_set_name
  end
end

@keywords= {}
def get_keyword_id(keyword)
  keyword.strip!
  if !(keyword_id = @keywords[keyword]).nil?
    keyword_id
  elsif !(Keyword.where(:name => keyword).first).nil?
    @keywords[keyword] = Keyword.where(:name => keyword).first.id
  else
    Keyword.create(:name => keyword).id
  end
end
