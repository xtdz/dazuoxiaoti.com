require 'spec_helper'

describe Benefit do
  let(:benefit) do
    stub_model(Benefit, :steps => 6)
  end

  it "calculates correct step count" do
    benefit.step(45, 30).should == 3
    benefit.step(30, 30).should == 6
    benefit.step(0, 30).should == 0
    benefit.step(20,20).should == 6
    benefit.step(15,20).should == 5
  end
end
