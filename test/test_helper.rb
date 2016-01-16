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

#class MiniTest::Spec
#  before :each do
#    DatabaseCleaner.start
#  end
#
#  after :each do
#    DatabaseCleaner.clean
#  end
#end

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
  # place here custom integration methods
end
