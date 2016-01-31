require 'rails_helper'

RSpec.describe "Sign Up Process", type: :feature do
  feature "for Sleeping Users" do
    before do
      sign_up!

      user_id = User.find_by(email: "arnaud@clubccex.com").id
      visit "/sessions/sign_up_sleeping_form/#{user_id}/"
    end

    it { expect(page).to have_css "#user_firstname[value='Arnaud']" }
    it { expect(page).to have_css "#user_lastname[value='Barbelet']" }
    it { expect(page).to have_css "#user_email[value='arnaud@clubccex.com']" }
    it { expect(page).to have_css "#user_recommenders_attributes_0_firstname" }
    it { expect(page).to have_css "#user_recommenders_attributes_1_email" }
  end
end
