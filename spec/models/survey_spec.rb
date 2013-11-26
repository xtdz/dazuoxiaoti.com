require 'spec_helper'

describe Survey do
  context "when answer a survey question" do
    let (:survey) {Factory(:survey)}
    it "increments the corresponding count if increase count is called" do
      survey.choices.should == [survey.choice1, survey.choice2, survey.choice3, survey.choice4]
      survey.counts.should == [0, 0, 0, 0]
      survey.increase_count("1")
      survey.counts.should == [0, 1, 0, 0]
      survey.increase_count("0")
      survey.counts.should == [1, 1, 0, 0]
      survey.increase_count("1")
      survey.counts.should == [1, 2, 0, 0]
      survey.increase_count("5")
      survey.counts.should == [1, 2, 0, 0]
      survey.increase_count("s")
      survey.counts.should == [1, 2, 0, 0]
    end
  end
end
