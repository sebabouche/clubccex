require 'test_helper'

class SignUpTest < Trailblazer::Test::Integration
  it do
    sign_up!

    user_id = User.find_by(email: "arnaud@clubccex.com").id
    visit "/sessions/sign_up_sleeping_form/#{user_id}/"

    # renders form
    page.must_have_css "#user_firstname[value='Arnaud']"
    page.must_have_css "#user_lastname[value='Barbelet']"
    page.must_have_css "#user_email[value='arnaud@clubccex.com']"
    page.must_have_css "#user_recommenders_attributes_0_firstname"
    page.must_have_css "#user_recommenders_attributes_1_email"
  end
end
