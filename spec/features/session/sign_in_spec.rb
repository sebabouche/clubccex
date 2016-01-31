require 'rails_helper'

RSpec.describe "Sign In Process", type: :feature do
  feature "Sign In" do
    scenario "renders Admin layout" do
      res, op = User::Create::Confirmed::Admin.run(user: {
        firstname: "Admin",
        lastname: "User",
        email: "admin@example.com"
      })

      visit "/"

      # Renders form
      expect(page).to have_css "input[name='session[email]']"
      expect(page).to have_css "input[name='session[password]']"

      # SignIn as Admin
      fill_in "session[email]", with: "admin@example.com"
      fill_in "session[password]", with: "password"
      click_button "Se connecter"

      expect(page).to have_css ".admin"
    end
  end
end
