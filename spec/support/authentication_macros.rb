require 'capybara/rspec'

module AuthenticationMacros
  def login_with_email(email, password)
    visit root_path
    click_link I18n.t(:'session.login')
    fill_in I18n.t(:'user.email'), :with => email
    fill_in I18n.t(:'user.password'), :with => password
    click_button I18n.t(:'session.login')
  end
end
