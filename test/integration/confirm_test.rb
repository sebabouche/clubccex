require 'test_helper'

class ConfirmTest < Trailblazer::Test::Integration
  feature "confirm unconfirmed" do
    it "confirms valid", js: true do
      sign_up!
      sign_in_as_admin!
      click_button "navburger"

      # From unconfirmed
      click_link "", href: '/users/unconfirmed'
      click_link "Confirmer cet utilisateur", match: :first
      page.must_have_css ".alert-info"
    end
  end
end
