require 'rails_helper'

RSpec.describe "Users Page", type: :feature do

  feature "scrolls infinitely" do
    before do
      sign_in_admin!
      60.times { create_user! }
      visit ("/users")
    end

    scenario "it scrolls", js: true do
      expect(page).to have_css ".profile-card", count: 24
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_css ".profile-card", count: 48
    end
  end
end
