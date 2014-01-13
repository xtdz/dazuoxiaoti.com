require 'spec_helper'

describe Answer do
  let(:answer) do
    Answer.new
  end

  it "is correct if set as correct" do
    answer.correct = true
    answer.correct?.should be_true
    answer.skipped?.should be_false
    answer.incorrect?.should be_false
  end

  it "is incorrect if set as incorrect" do
    answer.correct = false
    answer.correct?.should be_false
    answer.incorrect?.should be_true
    answer.skipped?.should be_false
  end
end
