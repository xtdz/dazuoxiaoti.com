require 'spec_helper'

describe User do
  let :valid_attr do
    {
      :name => 'foo bar',
      :nickname => 'foo',
      :email => 'foo@bar.com',
      :password => 'secret'
    }
  end

  let :invalid_attr do
    valid_attr.dup
  end


  context "when creating without authentication" do
    it "can be created with valid attributes" do
      User.create(valid_attr).should be_persisted
    end

    it "can be updated" do
      User.create valid_attr
      user = User.first
      user.name = 'Foo'
      user.save.should be_true
    end

    it "cannot be created without a nickname" do
      invalid_attr.delete :nickname
      user = User.create invalid_attr
      user.should_not be_persisted
    end

    it "cannot be created without a email" do
      invalid_attr.delete :email
      user = User.create invalid_attr
      user.should_not be_persisted
    end

    it "cannot be created without a password" do
      invalid_attr.delete :password
      invalid_attr.delete :password_confirmation
      user = User.create invalid_attr
      user.should_not be_persisted
    end

    it "cannot be created without credentials" do
      invalid_attr.delete :password
      invalid_attr.delete :email
      user = User.create invalid_attr
      user.should_not be_persisted
    end
  end

  context "when creating with authentication" do
    let :auth do
      stub_model(Authentication, {:valid? => true})
    end

    it "can be created without an email and password" do
      valid_attr[:authentication] = auth
      valid_attr.delete :email
      valid_attr.delete :password
      user = User.new valid_attr
      user.save.should be_true
    end

    it "cannot be created without a password if email is present" do
      valid_attr[:authentication] = auth
      valid_attr.delete :password
      user = User.new valid_attr
      user.save.should be_false
    end
  end

  context "when created with authentication" do
    let :sina_user do
      Factory(:sina_user)
    end

    it "can create valid email and password" do
      sina_user.update_attributes(valid_attr).should be_true
    end

    it "cannot create email without password" do
      invalid_attr.delete(:password)
      invalid_attr.delete(:password_confirmation)
      sina_user.update_attributes(invalid_attr).should be_false
    end

    it "cannot create email with invalid password" do
      invalid_attr[:password] = ""
      invalid_attr[:password_confirmation] = ""
      sina_user.update_attributes(invalid_attr).should be_false
    end

    it "cannot create password without email" do
      invalid_attr.delete(:email)
      sina_user.update_attributes(invalid_attr).should be_false
    end

    it "cannot create password with invalid email" do
      invalid_attr[:email] = ""
      sina_user.update_attributes(invalid_attr).should be_false
    end
  end
end
