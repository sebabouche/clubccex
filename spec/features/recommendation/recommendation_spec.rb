require 'rails_helper'

RSpec.describe "Recommendation flow", type: :feature do
  let (:reco1) { Recommendation.first }
  let (:reco2) { Recommendation.last }

  before do
    User::Create::Confirmed.(user: {firstname: "Arnaud", lastname: "Barb", email: "arnaud@example.com"})
    User::Create::Confirmed.(user: {firstname: "Matthieu", lastname: "Vett", email: "matt@example.com"})
    sign_up_user!
  end

  scenario "email has link to recommendation page" do
    expect(ActionMailer::Base.deliveries[1].body).to match "http://localhost:3000/recommendations/#{reco1.id}/edit\">"
    expect(ActionMailer::Base.deliveries[2].body).to match "http://localhost:3000/recommendations/#{reco2.id}/edit\">"
  end
    
  scenario "user can access recommendation page from email link", js: true do
    sign_in_user!("arnaud@example.com", "password")
    visit "/recommendations/#{reco1.id}/edit"

    expect(page).to have_css(".recommendation_confirmed")
  end

  scenario "user can access recommendations from dashboard" do
    sign_in_user!("arnaud@example.com", "password")
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

