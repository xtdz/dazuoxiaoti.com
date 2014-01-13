require 'spec_helper'

describe Achievement do
  let :project do
    Factory(:project)
  end

  let :user do
    Factory(:user)
  end

  context "when getting achievement by label" do
    it "returns a newly created achievement if none exists" do
      achievement = Achievement.get_achievement(:label)
      achievement.should be_persisted
      achievement.label.should == :label
    end

    it "returns an existing achievement if one exists" do
      achievement = Achievement.create :label => :label
      Achievement.get_achievement(:label).should == achievement
    end

    it "returns correct achievement for participation" do
      achievement = Achievement.get_achievement(:participation, :project => project)
      achievement.label.should == "participation_#{project.id}"
    end

    it "returns correct achievement for completion" do
      achievement = Achievement.get_achievement(:completion, :project => project)
      achievement.label.should == "completion_#{project.id}"
    end
  end

  context "when verifying participation" do
    it "returns false if participation doesn't exist" do
      Achievement.verify_participation(user, :project => project).should be_false
    end

    it "returns false if participation exists but correct_count is 0" do
      Participation.create :user_id => user.id, :project_id => project.id
      Achievement.verify_participation(user, :project => project).should be_false
    end

    it "returns true if participation exists and correct_count is 1" do
      Participation.create :user_id => user.id, :project_id => project.id, :correct_count => 1
      Achievement.verify_participation(user, :project => project).should be_true
    end
  end

  context "when veriftying completion" do
    it "returns false if participation doesn't exist" do
      Achievement.verify_completion(user, :project => project).should be_false
    end

    it "returns false if correct_count has not reached project rate" do
      Participation.create :user_id => user.id, :project_id => project.id
      Achievement.verify_completion(user, :project => project).should be_false
    end

    it "returns true if correct_count has reached project rate" do
      Participation.create :user_id => user.id, :project_id => project.id, :correct_count => project.rate
      Achievement.verify_completion(user, :project => project).should be_true
    end
  end

  context "whent triggering participation achievement" do
    it "does not award participation achievement if no participation exists" do
      Achievement.trigger(:participation, user, :project => project)
      user.awarded?(Achievement.get_achievement(:participation, :project => project)).should be_false
    end


    it "awards participation achievement if participation exists" do
      Participation.create :user_id => user.id, :project_id => project.id, :correct_count => 2
      Achievement.trigger(:participation, user, :project => project)
      user.awarded?(Achievement.get_achievement(:participation, :project => project)).should be_true
    end
  end

  context "whent triggering completion achievement" do
    it "does not award completion achievement if no completion exists" do
      Achievement.trigger(:completion, user, :project => project)
      user.awarded?(Achievement.get_achievement(:completion, :project => project)).should be_false
    end


    it "awards completion achievement if completion exists" do
      Participation.create :user_id => user.id, :project_id => project.id, :correct_count => project.rate
      Achievement.trigger(:completion, user, :project => project)
      user.awarded?(Achievement.get_achievement(:completion, :project => project)).should be_true
    end
  end

  context "when triggering achievements" do
    let :a1 do
      stub_model(Achievement, :id => 1, :label => 'a1')
    end

    let :a2 do
      stub_model(Achievement, :id => 2, :label => 'a2')
    end

    let :a3 do
      stub_model(Achievement, :id => 3, :label => 'a3')
    end

    before :each do
      Achievement.should_receive(:where).with(:label => a1.label).and_return [a1]
      Achievement.should_receive(:where).with(:label => a2.label).and_return [a2]
      Achievement.should_receive(:where).with(:label => a3.label).and_return [a3]
      Achievement.stub(:verify_a1).and_return true
      Achievement.stub(:verify_a2).and_return true
      Achievement.stub(:verify_a3).and_return true
    end

    it "can trigger multiple achievements in a row" do
      Achievement.trigger(a1.label, user, :project => project)
      Achievement.trigger(a2.label, user, :project => project)
      Achievement.trigger(a3.label, user, :project => project)
      Achievement.should_receive(:where).with(:id => [1,2,3]).and_return [a1, a2, a3]
      User.find(user.id).achievements
    end
  end
end
