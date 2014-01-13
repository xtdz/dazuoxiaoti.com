ENV['RAILS_ENV'] = 'cucumber'
Rails.env = 'cucumber'
require 'spork'

Spork.prefork do
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  require 'cucumber/rails'

  # Capybara.default_selector = :css

  ActionController::Base.allow_rescue = false
end

Spork.each_run do
  require 'factory_girl_rails'
  begin
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end
end
