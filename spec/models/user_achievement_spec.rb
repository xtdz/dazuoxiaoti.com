require 'spec_helper'

describe User do
  let :user do
    Factory(:user)
  end

  let :achievement do
    stub_model(Achievement, :id => rand(96) + 32)
  end

  context "when checking for whether an achievement has been awarded" do
    it "returns false for achievements that have not been awarded" do
      user.awarded?(achievement).should == false
    end

    it "returns true for achievements that have been awarded" do
      user.award(achievement)
      user.awarded?(achievement).should == true
    end
  end

  context "when looking achievements that have been awarded" do
    it "returns empty array when no achievement are found" do
      user.achievements.should be_empty
    end

    it "returns achievements if there is any" do
      a1 = stub_model(Achievement, :id => 1)
      a2 = stub_model(Achievement, :id => 2)
      user.award(a1)
      user.award(a2)
      Achievement.should_receive(:where).with(:id => [1, 2]).and_return([a1, a2])
      User.find(user.id).achievements
    end
  end
end
