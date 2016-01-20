require 'test_helper'

class WakeUpTest < Trailblazer::Test::Integration
  feature "WakeUp" do
    scenario "renders form" do
      sign_up!
      visit '/'
      click_link 'Inscription'
    end
  end
end
