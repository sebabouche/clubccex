require 'rails_helper'

RSpec.describe User::Search, type: :operation do
  let(:admin) { User::Create::Confirmed::Admin.(user: {
    firstname: "Admin",
    lastname: "Strator",
    email: "admin@clubccex.com"}).model }

  let(:user) { User::Create::Confirmed.(user: {
    firstname: "Sebabouche",
    lastname: "Nicolaïdis",
    email: "sebabouche@example.com"}).model }

  context "signed in" do
    it "filters by firstname" do
      user
      search = User::Search.present(current_user: user, q: {
        firstname_or_lastname_or_nickname_or_occupation_or_company_cont: "Sebabouche", 
        events_number_eq: ""}).model

      expect(search.first).to eq user
    end

    it "filters by lastname" do
      user
      search = User::Search.present(current_user: user, q: {
        firstname_or_lastname_or_nickname_or_occupation_or_company_cont: "Nicolaïdis", 
        events_number_eq: ""}).model

      expect(search.first).to eq user
    end

    it "filters by race number" do
      updated_user = User::Update.(id: user.id, user: {events: [{"number" => 23}, {"number" => 24}]}, current_user: user).model
      search = User::Search.present(current_user: user, q: {
        events_number_eq: "24"}).model

      expect(updated_user.events.first.number).to eq 23
      expect(search.first).to eq user
    end

    context "pagination" do
      before do
        25.times { User.create( firstname: Faker::Name.first_name, lastname: Faker::Name.last_name,
          email: Faker::Internet.email, confirmed: 1, sleeping: 0) }
      end

      it "shows 25 users per page" do
        search = User::Search.present({current_user: user})
        expect(search.model.count).to eq 25
      end

      it "paginates" do
        search = User::Search.present(current_user: user, page: 2)
        expect(search.model.count).to eq 1
      end
    end
  end

  context "policy" do
    before do
      User::Create::Unconfirmed.(user: {firstname: "Uncon", lastname: "Firmed", email: "un@confir.med"})
      User::Create::Unconfirmed::Sleeping.(user: {firstname: "Unconfirmed", lastname: "Sleeping", email: "un@confirmed.slp"})
      User::Create::Confirmed.(user: {firstname: "Con", lastname: "Firmed", email: "con@fir.med"})
      User::Create::Confirmed::Sleeping.(user: {firstname: "Con", lastname: "Sleeping", email: "conf@sleep.ing"})
    end

    it "for admin, shows confirmed" do
      # TODO Shows all users
      search = User::Search.present({current_user: admin})
      expect(search.model.count).to eq 2
    end

    it "for signed_in, shows confirmed" do
      search = User::Search.present({current_user: user})
      expect(search.model.count).to eq 2
    end
  end
end
