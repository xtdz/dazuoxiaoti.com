require 'spork'
require 'simplecov'
SimpleCov.start 'rails'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  require "rails/application"
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'database_cleaner'

  DatabaseCleaner.clean_with :truncation
end

Spork.each_run do
  require 'factory_girl_rails'

  # Reload models
  # Dir[Rails.root.join("app/model/**/*.rb")].each {|f| require f}

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    include AuthenticationMacros
    config.mock_with :rspec

    config.include Devise::TestHelpers, :type => :controller

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end
