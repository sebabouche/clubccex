require 'rails_helper'

RSpec.describe "Sign Up Process", type: :feature do
  feature "for Sleeping Users" do
    let (:user) { sign_up_user! }
    let (:recommender) { user.recommenders[0] }

    context "from sign up form" do
      scenario "can't sign up" do
        visit "/"
        click_link "Inscription"
        fill_in 'user[firstname]', with: recommender.firstname
        fill_in 'user[lastname]', with: recommender.lastname
        fill_in 'user[email]', with: recommender.email
        fill_in 'user[recommenders_attributes][0][firstname]', with: 'Matthieu'
        fill_in 'user[recommenders_attributes][0][lastname]', with: 'Vetter'
        fill_in 'user[recommenders_attributes][0][email]', with: 'mattvett@example.com'
        fill_in 'user[recommenders_attributes][1][firstname]', with: 'Patrick'
        fill_in 'user[recommenders_attributes][1][lastname]', with: 'Durich'
        fill_in 'user[recommenders_attributes][1][email]', with: 'patrick@example.com'
        click_button 'Envoyer'

        expect(page).to have_css ".has-error"
        expect(page).to have_css "a.btn[href='/sessions/send_sleeping_email/#{recommender.id}']"

        expect(ActionMailer::Base.deliveries.count).to eq 3
        click_link "Renvoyer l'email d'inscription"
        expect(ActionMailer::Base.deliveries.count).to eq 4
        expect(page).to have_css ".alert-info"
      end
    end

    context "renders form" do
      before do
        visit "/sessions/sign_up_sleeping_form/#{recommender.id}/"
      end

      it { expect(page).to have_css "#user_firstname[value='#{recommender.firstname}']" }
      it { expect(page).to have_css "#user_lastname[value='#{recommender.lastname}']" }
      it { expect(page).to have_css "#user_email[value='#{recommender.email}']" }
      it { expect(page).to have_css "#user_recommenders_attributes_0_firstname" }
      it { expect(page).to have_css "#user_recommenders_attributes_1_email" }
    end
  end
end
