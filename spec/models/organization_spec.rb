require 'spec_helper'

describe Organization do
  let :valid_attr do
    {
      :name => "ORG",
      :description => "ORG",
      :url => "http://www.org.org",
      :image_name => "org.png"
    }
  end

  let :invalid_attr do
    valid_attr.dup
  end

  it "can be created with valid attributes" do
    Organization.create(valid_attr).should be_persisted
    organization = Organization.first
    valid_attr.each do |key, value|
      organization.send(key).should == value
    end
  end
end
