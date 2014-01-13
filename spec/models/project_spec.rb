require 'spec_helper'

describe Project do
  let :coordinator do
    stub_model(Organization, :id => 1)
  end

  let :benefit do
    stub_model(Benefit, :id => 2)
  end

  let :sponsor do
    stub_model(Organization, :id => 3)
  end

  let :valid_attr do
    {
      :benefit => benefit,
      :coordinator => coordinator,
      :sponsor => sponsor,
      :rate => 100,
      :limit => 50
    }
  end

  let :invalid_attr do
    valid_attr.dup
  end

  it "can be created with valid attributes" do
    Project.create(valid_attr).should be_persisted
    project = Project.first
    valid_attr.each do |key, value|
      if [:benefit, :sponsor, :coordinator].include? key
        project.send("#{key}_id").should == value.id
      else
        project.send(key).should == value
      end
    end
  end

  it "defaults correct_count to 0" do
    project = Project.create valid_attr
    project.correct_count == 0
  end

  it "increments count as expected" do
    project = Project.create valid_attr
    project.increment(:correct_count)
    Project.first.correct_count.should == 1
  end
end
