require 'test_helper'

class SignUpTest < Trailblazer::Test::Integration
  feature "SignUp" do
    scenario "renders form" do
      visit '/'
      click_link 'Inscription'

      # renders form
      page.must_have_css "#user_firstname"
      page.must_have_css "#user_lastname"
      page.must_have_css "#user_email"
      page.must_have_css "#user_recommenders_attributes_0_firstname"
      page.must_have_css "#user_recommenders_attributes_1_email"
    end

    scenario "empty fields", js: true do
      visit '/'
      click_link 'Inscription'
      click_button 'Envoyer'

      page.must_have_css ".has-error"
      page.must_have_css "#user_firstname"
      page.must_have_css "#user_lastname"
      page.must_have_css "#user_email"
      page.must_have_css "#user_recommenders_attributes_0_firstname"
      page.must_have_css "#user_recommenders_attributes_1_email"
    end

    scenario "wrong recommender email", js: true do
      visit '/'
      click_link 'Inscription'
      fill_in 'user[firstname]', with: 'Sébastien'
      fill_in 'user[lastname]', with: 'Nicolaïdis'
      fill_in 'user[email]', with: 's.nicolaidis@me.com'
      fill_in 'user[recommenders_attributes][0][firstname]', with: 'Matthieu'
      fill_in 'user[recommenders_attributes][0][lastname]', with: 'Vetter'
      fill_in 'user[recommenders_attributes][0][email]', with: 'mattvett'
      fill_in 'user[recommenders_attributes][1][firstname]', with: 'Arnaud'
      fill_in 'user[recommenders_attributes][1][lastname]', with: 'Barbelet'
      fill_in 'user[recommenders_attributes][1][email]', with: 'abarbelet@gmail.com'
      click_button 'Envoyer'

      page.must_have_css '.has-error'
    end

    scenario "valid submit" do
      visit '/'
      click_link 'Inscription'
      fill_in 'user[firstname]', with: 'Sébastien'
      fill_in 'user[lastname]', with: 'Nicolaïdis'
      fill_in 'user[email]', with: 's.nicolaidis@me.com'
      fill_in 'user[recommenders_attributes][0][firstname]', with: 'Matthieu'
      fill_in 'user[recommenders_attributes][0][lastname]', with: 'Vetter'
      fill_in 'user[recommenders_attributes][0][email]', with: 'mattvett@gmail.com'
      fill_in 'user[recommenders_attributes][1][firstname]', with: 'Arnaud'
      fill_in 'user[recommenders_attributes][1][lastname]', with: 'Barbelet'
      fill_in 'user[recommenders_attributes][1][email]', with: 'abarbelet@gmail.com'
      click_button 'Envoyer'

      page.must_have_content "Merci"
    end
  end
end
