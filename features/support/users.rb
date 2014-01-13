module UserHelpers
  def new_user_for(identity)
    case identity
    when /^my email$/
      Factory.build(:user)
    when /^my sina account$/
      Factory.build(:sina_user)
    else
      raise "Invalid Identity"
    end
  end

  def existing_user_for(identity)
    user = new_user_for(identity)
    if user.save
      return user
    else
      raise "Failed to create user"
    end
  end

  def stub_authentication(authentication)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(authentication.provider, {
      'provider' => authentication.provider,
      'uid' => authentication.uid,
      'extra' => {'user_hash' => {'name' => 'foo'}}})
  end

  def auth_path(identity)
    case identity
    when /^my sina account$/
      '/users/auth/tsina'
    else
      raise 'Unsupported Identity'
    end
  end
end

World(UserHelpers)
