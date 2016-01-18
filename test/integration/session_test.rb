require 'test_helper'

class SessionTest < Trailblazer::Test::Integration
  it do
    require_js
    visit '/'
    click_link 'Inscription'

    # renders form
    page.must_have_css "#user_firstname"
    page.must_have_css "#user_lastname"
    page.must_have_css "#user_email"
    page.must_have_css "#user_recommenders_attributes_0_firstname"
    page.must_have_css "#user_recommenders_attributes_1_email"

    # wrong submit all empty
    click_button 'Envoyer'

    page.must_have_css ".has-error"
    page.must_have_css "#user_firstname"
    page.must_have_css "#user_lastname"
    page.must_have_css "#user_email"
    page.must_have_css "#user_recommenders_attributes_0_firstname"
    page.must_have_css "#user_recommenders_attributes_1_email"

    # wrong recommender email
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

    # valid submit
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

    # sign up sleeping
    visit "/sessions/sign_up_sleeping_form/2/"

    # renders form
    page.must_have_css "#user_firstname[value='Matthieu']"
    page.must_have_css "#user_lastname[value='Vetter'"
    page.must_have_css "#user_email[value='mattvett@gmail.com']"
    page.must_have_css "#user_recommenders_attributes_0_firstname"
    page.must_have_css "#user_recommenders_attributes_1_email"
  end
end
