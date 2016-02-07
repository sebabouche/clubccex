require 'rails_helper'

RSpec.describe "Sign out flow", type: :feature do
  it "signs out" do
    sign_up_and_confirm_user!
    sign_in_user!
    expect(page).to have_css ".logged"

    click_link "Déconnexion"
    expect(page).to have_css ".anonymous"
  end
end

