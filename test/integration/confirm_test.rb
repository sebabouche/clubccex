require 'test_helper'

class ConfirmTest < Trailblazer::Test::Integration
  feature "confirm unconfirmed" do
    it "confirms valid", js: true do
      sign_up!
      visit "/create_admin"
      visit "/"
      fill_in 'session[email]', with: "halo1979@hallo20.com"
      fill_in 'session[password]', with: "password"
      click_button "Se connecter"
      click_button "navburger"

      # From unconfirmed
      click_link "", href: '/users/unconfirmed'
      click_link "Confirmer cet utilisateur", match: :first
      page.must_have_css ".alert-info"
    end
  end
end
