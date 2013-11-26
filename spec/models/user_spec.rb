require 'spec_helper'

describe User do
  let (:user) { Factory :user }
  let (:project) { Factory :project }
  let (:question) { Factory :question }
  let (:incorrect_answer) { Answer.new :state => 0, :question => question }
  let (:correct_answer) { Answer.new :state => 1, :question => question }
  let (:skipped_answer) { Answer.new :state => 2, :question => question }

  context "when answered a question" do
    before :each do
      user.correct_count = user.incorrect_count = user.skipped_count = 0
      user.save
      user.stub(:valid_answer?) { true }
      user.stub(:valid_project?) { true }
    end

    after :each do
      u = User.first
      u.answers.should include(incorrect_answer)
      u.answers.should include(correct_answer)
      u.answers.should include(skipped_answer)
      u.correct_count.should == 1
      u.skipped_count.should == 1
      u.incorrect_count.should == 1
      p = u.participations.first
      p.correct_count.should == 1
      p.skipped_count.should == 1
      p.incorrect_count.should  == 1
      p.project.should == project
    end

    it "adds answers correctly" do
      user.add_answer_for_project incorrect_answer, project
      user.add_answer_for_project correct_answer, project
      user.add_answer_for_project skipped_answer, project
    end

    it "adds answer list correctly" do
      answer_list = [correct_answer, incorrect_answer, skipped_answer]
      user.add_answers_for_project answer_list, project
    end
  end

  context "when getting next question" do
    it "returns nil if all of user's question_sets are empty" do
      user.question_sets << QuestionSet.new(:name => 'qs1')
      user.question_sets << QuestionSet.new(:name => 'qs2')
      user.get_next_question.should == nil
    end

    it "returns unanswered question from a users's question_set" do
      qs1 = QuestionSet.new(:name => 'qs1')
      qs2 = QuestionSet.new(:name => 'qs2')
      user.question_sets << qs1 << qs2
      qs2.questions << question
      user.get_next_question.should == question
    end

    it "returns nil if all questions in user's question_sets  are answered" do
      qs1 = QuestionSet.new(:name => 'qs1')
      qs2 = QuestionSet.new(:name => 'qs2')
      user.question_sets << qs1 << qs2
      qs2.questions << question
      user.answers << incorrect_answer
      user.answers << correct_answer
      user.get_next_question.should == nil
    end

    context "when getting sponsor question" do
      before :each do
        @sponsor_id = 1
        question.sponsor_id = @sponsor_id
        question.save
      end

      it "returns nil if all sponsor questions are answered" do
        user.answers << correct_answer
        user.get_next_sponsor_question(@sponsor_id).should == nil
      end

      it "returns a random sponsor question" do
        user.get_next_sponsor_question(@sponsor_id).should == question
      end
    end
  end

  context "when finding most recent project" do
    it "returns nil if none exists" do
      user.most_recent_project.should == nil
    end

    it "returns a project if one exist" do
      participation = Factory :participation
      participation.user.most_recent_project.should == participation.project
    end
  end
end
