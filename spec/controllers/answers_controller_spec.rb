require 'spec_helper'

describe AnswersController do
  let(:question) { Factory(:question) }
  let(:answer_attr) { {:choice => question.correct_answer} }
  let(:wrong_answer_attr) { {:choice => question.choices[(question.correct_index+1)%4]} }

  let(:project) { Factory(:project) }
  let(:referer) { Factory(:user) }

  it "assigns question, answer and project" do
    post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
    assigns[:project].should == project
    assigns[:question].should == question
    assigns[:answer].should be_correct
  end

  #it "redirects to root_path if project does not exist" do
  #  post :create, :question_id => question.id, :answer => answer_attr
  #  response.should redirect_to(root_path)
  #end

  context "when submit as anoynomous user" do
    it "does not save answer" do
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      assigns[:answer].should_not be_persisted
    end

    it "increments project correct_count" do
      count = project.correct_count
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      Project.first.correct_count.should == count + 1
    end

    it "increments referer's total contribution" do
      session[:referer_id] = referer.id
      contribution = referer.contribution
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      User.find(referer.id).contribution.should == contribution + 1
    end

    it "increments referer's participation contribution" do
      session[:referer_id] = referer.id
      contribution = referer.project_contribution(project.id)
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      User.find(referer.id).project_contribution(project.id).should == contribution + 1
    end

    it "saves answer in session" do
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      (session[:answers].is_a? Hash).should == true
      (session[:answers][project.id].is_a? Array).should == true
      session[:answers][project.id].should_not be_empty
    end
  end

  context "when submit as user" do
    let :user do
      Factory(:user)
    end

    before :each do
      sign_in user
    end

    it "saves answer if user has not completed the question" do
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      assigns[:answer].should be_persisted
      Answer.find(assigns[:answer].id).user.should == user
    end

    it "does not save answer if user has completed the question" do
      user.answers.create :question_id => question.id, :choice => question.correct_answer, :state => 1
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      assigns[:answer].should_not be_persisted
      assigns[:answer].user.should be_nil
    end

    it "increments project correct_count" do
      count = project.correct_count
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      Project.first.correct_count.should == count + 1
    end

    it "increments project in_correct_count" do
      count = project.incorrect_count
      post :create, :question_id => question.id, :answer => wrong_answer_attr, :project_id => project.id
      Project.first.incorrect_count.should == count + 1
    end

    it "increments user correct_count" do
      count = user.correct_count
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      User.find(user.id).correct_count == count + 1
      user.correct_count == count + 1
    end

    it "increments referer's total contribution" do
      session[:referer_id] = referer.id
      contribution = referer.contribution
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      User.find(referer.id).contribution.should == contribution + 1
    end

    it "increments referer's participation contribution" do
      session[:referer_id] = referer.id
      contribution = referer.project_contribution(project.id)
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      User.find(referer.id).project_contribution(project.id).should == contribution + 1
    end

    it "saves referer if current user has not participated in current project" do
      session[:referer_id] = referer.id
      post :create, :question_id => question.id, :answer => answer_attr, :project_id => project.id
      participation = user.participations.where(:project_id => project.id).first
      participation.referer_id.should == referer.id
    end

    it "does not save referer if current user has participated in current project" do
      session[:referer_id] = referer.id
      Participation.create :user_id => user.id, :project_id => project.id, :project_id => project.id
      post :create, :question_id => question.id, :answer => answer_attr
      participation = user.participations.where(:project_id => project.id).first
      participation.referer_id.should be_nil
    end
  end
end
