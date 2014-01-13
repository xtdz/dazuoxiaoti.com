require 'spec_helper'

describe QuestionSet do
  let :question_set do
    Factory :question_set
  end

  it "Can hold Questions" do
    q1 = Factory :question
    q2 = Factory :question
    question_set.questions << q1
    question_set.questions << q2
    QuestionSet.first.questions.should include(q1)
    QuestionSet.first.questions.should include(q2)
  end

  it "Can be bookmarked by user" do
    user = Factory :user
    user.question_sets << question_set
    User.first.question_sets.should include(question_set)
  end
end
