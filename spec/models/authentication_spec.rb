require 'spec_helper'

describe Authentication do
  let :valid_attr do
    {
      :provider => 'tsina',
      :uid => '12345'
    }
  end

  let :invalid_attr do
    valid_attr.dup
  end

  it "be created with valid attributes" do
    auth = Authentication.create valid_attr
    auth.should be_persisted
  end

  it "cannot be created if provider is blank" do
    invalid_attr.delete :provider
    auth = Authentication.create invalid_attr
    auth.should_not be_persisted
  end

  it "cannot be created if uid is blank" do
    invalid_attr.delete :uid
    auth = Authentication.create invalid_attr 
    auth.should_not be_persisted
  end

  it "can link to user" do
    user = Factory(:user)
    auth = Authentication.create valid_attr
    Authentication.update auth.id, :user => user
    user.authentication(true).should == auth
  end

  it "can be found by provider and uid" do
    sina_user = Factory(:sina_user)
    auth = sina_user.authentication
    actual = Authentication.find_by_provider_and_uid auth.provider, auth.uid
    actual.should == auth
    actual.user.should == sina_user
  end
end
