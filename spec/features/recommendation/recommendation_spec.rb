require 'rails_helper'

RSpec.describe "Recommendation flow", type: :feature do
  let (:confirmed1) {User::Create::Confirmed.(user: {
    firstname: "Arnaud", 
    lastname: "Barbelet", 
    email: "arnaud@clubccex.com"}).model }

  let (:reco1) { Recommendation.first }
  let (:reco2) { Recommendation.last }

  before do
    User::Create::Confirmed.(user: {firstname: "Arnaud", lastname: "Barblelet", email: "arnaud@clubccex.com"})
    User::Create::Confirmed.(user: {firstname: "Matthieu", lastname: "Vetter", email: "matthieu@clubccex.com"})
    sign_up!
  end

  scenario "email has link to recommendation page" do
    expect(ActionMailer::Base.deliveries[1].body).to match "http://localhost:3000/recommendations/#{reco1.id}/edit\">"
    expect(ActionMailer::Base.deliveries[2].body).to match "http://localhost:3000/recommendations/#{reco2.id}/edit\">"
  end
    
  scenario "user can access recommendation page from email link" do
    sign_in!
    visit "/recommendations/#{reco1.id}/edit"

    expect(page).to have_css(".recommendation_confirmed")
  end

  scenario "user can access recommendations from dashboard" do
    sign_in!
    visit "/"
    expect(page).to have_css "a[href='/recommendations']", text: "Confirmations en attente (1)"

    click_link "Confirmations en attente (1)"
    expect(page).to have_css(".recommendation_confirmed")
    choose('Oui')
    click_button 'Valider'
    expect(page).to have_css ".alert-info"
    expect(page).to have_content "Pas de recommandation en attente"
  end
end

