require 'rails_helper'

RSpec.describe User::Confirm, type: :feature do
  context "Logged as admin" do
    before do
      sign_up!
      sign_in_as_admin!
    end

    context "Unconfirmed Page" do
      before do
        click_button "navburger"
        click_link "", href: '/users/unconfirmed'
      end

      it { expect(page).to have_css "a.btn", text: "Confirmer cet utilisateur", count: 3 }

      scenario "it confirms user" do
        click_link "Confirmer cet utilisateur", match: :first

        expect(page).to have_css ".alert-info", text: "confirmé!"
      end
    end

    context "Users Page" do
      before do
        click_button "navburger"
        click_link "", href: '/users'
      end

      it { expect(page).to have_css "a.btn", text: "Confirmer cet utilisateur" }

      scenario "it confirms user" do
        click_link "Confirmer cet utilisateur", match: :first

        expect(page).to have_css ".alert-info", text: "confirmé!"
      end
    end
  end
end
