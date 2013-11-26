Given /^no account exist for (.*)$/ do |identity|
  @user = new_user_for(identity)
end

Given /^an account exists for (.*)$/ do |identity|
  @user = existing_user_for(identity)
end

Given /^I am on the registration page$/ do
  visit new_user_registration_path
end

When /^I register an account with my email$/ do
  visit new_user_registration_path
  fill_in I18n.t(:'formtastic.labels.user.email'), :with => @user.email
  fill_in I18n.t(:'formtastic.labels.user.password'), :with => @user.password
  fill_in I18n.t(:'formtastic.labels.user.password_confirmation'), :with => @user.password
  fill_in I18n.t(:'formtastic.labels.user.nickname'), :with => @user.nickname
  fill_in I18n.t(:'formtastic.labels.user.name'), :with => @user.nickname
  click_on I18n.t(:'formtastic.actions.register')
end

When /^I authenticate with (.*)$/ do |identity|
  @user.authentication.should_not be_nil
  stub_authentication(@user.authentication)
  visit auth_path(identity)
end

Then /^I should be signed in as a new user identified by (.*)$/ do |identity|
  page.should have_content(I18n.t :'user.session.logout')
end

Then /^I should be signed in as an existing user identified by (.*)$/ do |identity|
  page.should have_content(I18n.t :'user.session.logout')
end

