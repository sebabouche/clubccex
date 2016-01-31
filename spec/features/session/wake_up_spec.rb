require 'rails_helper'

RSpec.describe Session::WakeUp, type: :operation do

  feature "Session::WakeUp" do
    before do
      user = create_confirmed_sleeping!
      confirmation_token = Tyrant::Authenticatable.new(user).confirmation_token
      visit "/sessions/wake_up_form/#{user.id}/?confirmation_token=#{confirmation_token}"
    end

    scenario "renders form" do
      expect(page).to have_content "Propre, Paul"
      expect(page).to have_css "#user_password"
      expect(page).to have_css "#user_confirm_password"
    end

    context "with wrong submit" do
      before do
        fill_in "user[password]", with: "password"
        fill_in "user[password]", with: "wrong"
        click_button "Enregistrer mon mot de passe"
      end

      scenario "renders form" do
        expect(page).to have_css "#user_password"
        expect(page).to have_css "#user_confirm_password"
      end

      scenario "renders errors", js: true do
        expect(page).to have_css ".has-error"
      end
    end

    context "with valid submit" do
      before do
        fill_in "user[password]", with: "123123123"
        fill_in "user[confirm_password]", with: "123123123"
        click_button "Enregistrer mon mot de passe"
      end

      scenario "shows login form" do
        expect(page).to have_css ".alert-info"
        expect(page).to have_css "#session_password"
        expect(page).to have_css "#session_email"
      end
    end
  end
end
