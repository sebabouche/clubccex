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
  include FactoryGirl::Syntax::Methods

  after :each do
    DatabaseCleaner.clean
    ActionMailer::Base.deliveries = []
  end

  # place here custom integration methods
  def sign_up!
    visit '/'
    click_link 'Inscription'
    fill_in 'user[firstname]', with: "Sébastien"
    fill_in 'user[lastname]', with: "Nicolaïdis"
    fill_in 'user[email]', with: "sebastien@clubccex.com"
    fill_in 'user[recommenders_attributes][0][firstname]', with: "Arnaud"
    fill_in 'user[recommenders_attributes][0][lastname]', with: "Barbelet"
    fill_in 'user[recommenders_attributes][0][email]', with: "arnaud@clubccex.com"
    fill_in 'user[recommenders_attributes][1][firstname]', with: "Matthieu"
    fill_in 'user[recommenders_attributes][1][lastname]', with: "Vetter"
    fill_in 'user[recommenders_attributes][1][email]', with: "matthieu@clubccex.com"
    click_button 'Envoyer'
  end

  def sign_up_sleeping!
    sign_up!
    visit "/sessions/sign_up_sleeping_form/2/"
    fill_in 'user[recommenders_attributes][0][firstname]', with: "Baptiste"
    fill_in 'user[recommenders_attributes][0][lastname]', with: "Auzeau"
    fill_in 'user[recommenders_attributes][0][email]', with: "baptiste@clubccex.com"
    fill_in 'user[recommenders_attributes][1][firstname]', with: "Romain"
    fill_in 'user[recommenders_attributes][1][lastname]', with: "Bastide"
    fill_in 'user[recommenders_attributes][1][email]', with: "romain@clubccex.com"
    click_button 'Envoyer'
  end

  def sign_in_as_admin!
    visit "/create_admin"
    visit "/"
    fill_in 'session[email]', with: "halo1979@hallo20.com"
    fill_in 'session[password]', with: "password"
    click_button "Se connecter"
  end

  def create_user!
    User.create!(
      firstname: Faker::Name.first_name,
      lastname: Faker::Name.last_name,
      email: Faker::Internet.email,
      confirmed: 1,
      sleeping: 0
    )
  end
end
