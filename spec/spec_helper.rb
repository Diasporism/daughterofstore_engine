require 'factory_girl_rails'
require 'rspec-rails'
require 'simplecov'
require 'time'
SimpleCov.start do
  add_filter '/spec'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'support/stripe_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include Rails.application.routes.url_helpers
  config.include FactoryGirl::Syntax::Methods
end

