require 'rails_helper'

RSpec.describe "Sign Up Process", type: :feature do
  feature "for Sleeping Users" do
    before do
      user = sign_up_user!
      visit "/sessions/sign_up_sleeping_form/#{user.recommenders[0].id}/"
    end

    it { expect(page).to have_css "#user_firstname[value='Arnaud']" }
    it { expect(page).to have_css "#user_lastname[value='Barb']" }
    it { expect(page).to have_css "#user_email[value='arnaud@example.com']" }
    it { expect(page).to have_css "#user_recommenders_attributes_0_firstname" }
    it { expect(page).to have_css "#user_recommenders_attributes_1_email" }
  end
end
