require 'spec_helper'

describe SessionManager do
  let :session do
    {}
  end

  let :controller do
    mock(ApplicationController, :signed_in? => true, :current_user => (Factory :user))
  end

  let :manager do
    SessionManager.new session, controller
  end

  context "when changing count down" do
    it "initializes countdown to 10" do
      manager.count_down.should == 10
    end

    it "decrements count_down on second call" do
      session[:count_down] = 9
      manager.count_down.should == 8
    end
  end

  context "when adding answer" do
    let :project do
      stub_model(Project)
    end

    let :answer do
      stub_model(Answer)
    end

    before :each do
      manager.stub(:current_project).and_return project
    end

    it "updates session expire time" do
      session[:expires_at] = 0
      manager.add_answer answer
      session[:expires_at].should > Time.now
    end

    it "increments respecitve counters" do
      answer.state = 0
      manager.add_answer answer
      project.incorrect_count.should == 1

      answer.state = 1
      manager.add_answer answer
      project.correct_count.should == 1

      answer.state = 2
      manager.add_answer answer
      project.skipped_count.should == 1
    end

    it "increments participation count correctly" do
      answer.state = 1
      manager.add_answer answer
      project.participation_count.should == 1

      manager.add_answer answer
      project.participation_count.should == 1
    end
  end
end
