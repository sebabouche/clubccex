require 'rails_helper'

RSpec.describe Session::SignUp, type: :feature do

  feature "Renders Form" do
    before do
      visit '/'
      click_link 'Inscription'
    end

    # renders form
    it { expect(page).to have_css "#user_firstname" }
    it { expect(page).to have_css "#user_lastname" }
    it { expect(page).to have_css "#user_email" }
    it { expect(page).to have_css "#user_recommenders_attributes_0_firstname" }
    it { expect(page).to have_css "#user_recommenders_attributes_1_email" }
  end

  feature "Renders errors if empty fields", js: true do
    before do
      visit '/'
      click_link 'Inscription'
      click_button 'Envoyer'
    end

    it { expect(page).to have_css ".has-error" }
    it { expect(page).to have_css "#user_firstname" }
    it { expect(page).to have_css "#user_lastname" }
    it { expect(page).to have_css "#user_email" }
    it { expect(page).to have_css "#user_recommenders_attributes_0_firstname" }
    it { expect(page).to have_css "#user_recommenders_attributes_1_email" }
  end

  feature "Renders errors with wrong recommender email", js: true do
    before do
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
    end

    it { expect(page).to have_css '.has-error' }
  end

  feature "Renders thank you page with valid submit" do
    before do
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
    end

    it { expect(page).to have_content "Merci" }
  end
end
