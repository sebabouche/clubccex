require 'test_helper'

class SignUpTest < Trailblazer::Test::Integration
  it do
    sign_up!

    visit "/sessions/sign_up_sleeping_form/2/"

    # renders form
    page.must_have_css "#user_firstname[value='Arnaud']"
    page.must_have_css "#user_lastname[value='Barbelet']"
    page.must_have_css "#user_email[value='arnaud@clubccex.com']"
    page.must_have_css "#user_recommenders_attributes_0_firstname"
    page.must_have_css "#user_recommenders_attributes_1_email"
  end
end
