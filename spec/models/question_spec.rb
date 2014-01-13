require 'spec_helper'

describe Question do
  let :question do
    Factory(:question)
  end

  it "it returns the correct answer" do
    answer = question.correct_answer
    case question.correct_index
    when 0
      answer.should == question.c1
    when 1
      answer.should == question.c2
    when 2
      answer.should == question.c3
    else
      answer.should == question.c4
    end
  end

  it "it keeps track of correct answer after shuffle" do
    answer = question.correct_answer
    question.shuffle
    question.correct_answer.should == answer
  end

  context "when searching by token" do
    it "should return nil if token is nil" do
      Question.find_by_token(nil).should == nil
    end

    it "should return nil if token is not exactly 40 bytes long" do
      Question.find_by_token('12345').should == nil
    end

    it "should return the correct question if token is correct" do
      Question.find_by_token(question.token).should == question
    end
  end

  context "when getting unanswered questions for a specific user" do
    it "excludes questions answered correctly by user" do
      correct_answer = Factory :correct_answer
      Question.for_user(correct_answer.user_id).count.should == 0
    end

    it "excludes questions skipped by user" do
      skipped_answer = Factory :skipped_answer
      Question.for_user(skipped_answer.user_id).count.should == 0
    end

    it "includes questions answered incorrectly by user" do
      incorrect_answer = Factory :incorrect_answer
      Question.for_user(incorrect_answer.user_id).should include(incorrect_answer.question)
    end

    it "includes questions not yet answered by user" do
      question = Factory :question
      user = Factory :user
      Question.for_user(user.id).should include(question)
    end
  end

  context "when retriving question randomly" do
    it "returns only one question" do
      q1 = Factory :question
      q2 = Factory :question
      q3 = Factory :question
      Question.random.size.should == 1
    end

    it "nests with for_user correctly" do
      correct_answer = Factory :correct_answer
      question = Factory :question
      Question.count.should == 2
      Question.for_user(correct_answer.user_id).random.should include(question)
    end
  end

  context "when retriving question by sponsor_id" do
    it "includes questions from the sponsor" do
      question = Factory :question
      question.sponsor_id = 1
      question.save
      Question.by_sponsor(1).should include(question)
    end

    it "excludes questions not from the sponsor" do
      question = Factory :question
      Question.by_sponsor(1).count.should == 0
    end
  end
end
