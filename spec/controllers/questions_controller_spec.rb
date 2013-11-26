require 'spec_helper'

describe QuestionsController do
  let :question do
    Factory(:question)
  end

  let :project do
    Factory(:project)
  end

  let :referer do
    Factory(:user)
  end

  context "when showing a question by token" do
    it "sets referer id if one exists" do
      get :show, :id => question.token, :referer_id => referer.id, :project_id => project.id
      session[:referer_id].should == referer.id
    end

    it "assigns the correct_question" do
      get :show, :id => question.token, :project_id => project.id
      assigns[:question].should == question
    end

    it "assigns the correct project" do
      get :show, :id => question.token, :project_id => project.id
      assigns[:project].should == project
    end

    #TODO: Fallback mechanism should be better than this
    #it "assigns the last project when missing project_id" do
    #  Project.should_receive(:last).and_return(project)
    #  get :show, :id => question.token
    #  assigns[:project].should == project
    #end
  end

  context "when skipping a question" do
    it "assigns the correct_question" do
      get :skip, :id => question.id, :project_id => project.id
      assigns[:question].should == question
    end

    it "assigns the correct project" do
      get :skip, :id => question.id, :project_id => project.id
      assigns[:project].should == project
    end

    it "increases project skip count" do
      skipped_count = project.skipped_count
      get :skip, :id => question.id, :project_id => project.id
      assigns[:project].skipped_count.should == skipped_count + 1
    end

    it "saves answer in session" do
      get :skip, :id => question.id, :project_id => project.id
      (session[:answers].is_a? Hash).should == true
      (session[:answers][project.id].is_a? Array).should == true
      session[:answers][project.id].should_not be_empty
    end

    # it "redirects to root_path when project_id is not present" do
    #   get :skip, :id => question.id
    #   response.should redirect_to(root_path)
    # end
  end

  context "when showing a random question" do
    before :each do
      session[:current_project_id] = project.id
      question
    end

    it "assigns a question" do
      get :random
      assigns[:question].should == question
    end

    it "assigns the correct project" do
      get :random, :project_id => project.id
      assigns[:project].should == project
    end

    # it "show last project if project_id is not present" do
    #   session[:current_project_id] = nil
    #   p2 = Factory :project
    #   get :random
    #   assigns[:project].should == p2
    # end

    it "assigns sponsor question when needed" do
      manager = mock(SessionManager, {:current_project => project, :current_project_id= => project.id, :count_down => 0, :current_url= => nil})
      controller.stub!(:session_manager).and_return(manager)
      controller.stub!(:rand).and_return 0
      sponsor_question = Factory :question, :sponsor_id => project.sponsor_id
      Question.should_receive(:by_sponsor).with(project.sponsor_id).and_return(Question.where(:id => sponsor_question.id))
      get :random
      assigns[:question].should == sponsor_question
    end
  end
end
