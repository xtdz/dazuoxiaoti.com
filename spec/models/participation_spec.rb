require 'spec_helper'

describe Participation do
  let :user do
    Factory(:user)
  end

  let :referer do
    Factory(:user)
  end

  let :project do
    Factory(:project)
  end

  let :participation do
    Participation.create :user => user, :project => project, :referer => referer
  end

  context "when incrementing participation correct count" do
    before :each do
      participation.stub(:increment_referer_contribution).and_return
    end

    it "increments correct count" do
      count = participation.correct_count
      participation.increment_counter :correct_count
      participation.correct_count.should == count + 1
    end

    it "increments referer contribution" do
      participation.should_receive(:increment_referer_contribution)
      participation.increment_counter :correct_count
    end
  end

  context "when incrementing participation incorrect count" do
    it "increments incorrect count" do
      count = participation.incorrect_count
      participation.increment_counter :incorrect_count
      participation.incorrect_count.should == count + 1
    end

    it "does not increment referer contribution" do
      participation.should_not_receive(:increment_referer_contribution)
      participation.increment_counter :incorrect_count
    end
  end

  context "when incrementing participation skipped count" do
    it "increments skipped count" do
      count = participation.skipped_count
      participation.increment_counter :skipped_count
      participation.skipped_count.should == count + 1
    end

    it "does not increment referer contribution" do
      participation.should_not_receive(:increment_referer_contribution)
      participation.increment_counter :skipped_count
    end
  end

  context "when incrementing referer contribution" do
    it "increments referer's contribution" do
      contribution = referer.contribution
      participation.increment_referer_contribution
      User.find(referer.id).contribution.should == contribution + 1
    end

    context "and referer participation exists" do
      it "increments referer's participation contribution " do
        contribution = 10
        Participation.create :project_id => project.id, :user_id => referer.id, :contribution => 10
        participation.increment_referer_contribution
        Participation.user(referer.id).project(project.id).first.contribution.should == contribution + 1
      end
    end

    context "and referer participation does not exist" do
      it "creates referer participation" do
        participation.increment_referer_contribution
        Participation.user(referer.id).project(project.id).first.should_not be_nil
      end

      it "increment referer's participation contribution" do
        participation.increment_referer_contribution
        Participation.user(referer.id).project(project.id).first.contribution.should == 1
      end
    end
  end

  context "when gettng participation for user, project pair" do
    context "and the participation exists" do
      before :each do
        @participation = Participation.create :project_id => project.id, :user_id => user.id, :contribution => 10
      end

      it "returns the correct participation" do
        Participation.get_participation_by_id(user.id, project.id).id.should == @participation.id
      end

      it "does not update project participation count" do
        count = project.participation_count
        Participation.get_participation_by_id(user.id, project.id).project.participation_count.should == count
      end
    end

    context "and the participation does not exist" do
      it "creates user participation" do
        Participation.get_participation_by_id user.id, project.id
        Participation.user(user.id).project(project.id).first.should_not be_nil
      end

      it "updates project participation count" do
        count = project.participation_count
        Participation.get_participation(user, project).project.participation_count.should == count + 1
        project.participation_count.should == count + 1
        project.participation_count.should == count + 1
      end
    end
  end

  context "when getting the most recent participation" do
    it "returns the most recently modified participation" do
      p1 = Factory :participation
      p2 = Factory :participation
      p3 = Factory :participation
      sleep(1)
      p2.increment_counter :correct_count
      Participation.recents.limit(1).first.should == p2
    end
  end
end
