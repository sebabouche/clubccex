require 'test_helper'

class SignInTest < Trailblazer::Test::Integration
  feature "Sign In" do
    scenario "Admin" do
      res, op = User::Create::Confirmed::Admin.run(user: {
        firstname: "Admin",
        lastname: "User",
        email: "admin@example.com"
      })

      visit "/"

      # Renders form
      page.must_have_css "input[name='session[email]']"
      page.must_have_css "input[name='session[password]']"

      # SignIn as Admin
      fill_in "session[email]", with: "admin@example.com"
      fill_in "session[password]", with: "password"
      click_button "Se connecter"

      page.must_have_css ".admin"
    end
  end
end


