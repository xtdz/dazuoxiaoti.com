class Users::PasswordsController < Devise::PasswordsController
  before_filter :authenticate_user!
end
