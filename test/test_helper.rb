ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/autorun"
require "trailblazer/rails/test/integration"

require "minitest/reporters"
Minitest::Reporters.use!

Rails.backtrace_cleaner.remove_silencers!

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

Capybara.default_driver = :selenium

module PossibleJSDriver
  def require_js
    Capybara.current_driver = :selenium
  end

  def teardown
    super
    Capybara.use_default_driver
  end
end

MiniTest::Spec.class_eval do
  after :each do
    DatabaseCleaner.clean
    ActionMailer::Base.deliveries = []
  end
end

Cell::TestCase.class_eval do
  include Capybara::DSL
  include Capybara::Assertions
end


Trailblazer::Test::Integration.class_eval do
  after :each do
    DatabaseCleaner.clean
  end

  include PossibleJSDriver
  # place here custom integration methods
end
