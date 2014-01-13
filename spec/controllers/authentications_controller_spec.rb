require 'spec_helper'

describe AuthenticationsController do
  let :sina_user do
    sina_user = Factory.build(:sina_user)
  end

  let :auth do
    sina_user.authentication
  end

  let :auth_hash do
    {
      'provider' => auth.provider,
      'uid' => auth.uid,
      'user_info' => {'username' => sina_user.nickname},
      'extra' => {'user_hash' => {'name' => sina_user.nickname}}
    }
  end

  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user] 
    request.env["omniauth.auth"] = auth_hash
  end

  it "signs in an existing user" do
    sina_user.save
    get :tsina
    assigns(:user).should eq(sina_user)
    assigns(:auth).should == auth
    signed_in?.should be_true
  end

  it "signs in an new user" do
    get :tsina
    signed_in?.should be_true
  end

  it "creates a new user when no auth exists" do
    User.should_receive(:new).with(:nickname => sina_user.nickname).and_return(sina_user)
    sina_user.should_receive(:build_authentication).with(
      :provider => auth.provider, :uid => auth.uid).and_return(auth)
    get :tsina
    assigns(:user).should == sina_user
    assigns(:auth).should == auth
    sina_user.should be_persisted
    auth.should be_persisted
    sina_user.authentication.should == auth
  end

  def signed_in?
    flash[:notice].should == I18n.t(:'devise.sessions.signed_in')
  end
end
