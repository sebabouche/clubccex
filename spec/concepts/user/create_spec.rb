require 'rails_helper'

RSpec.describe User::Create, type: :operation do 
  let (:valid_user) { User::Create.(
    user: {
      email: "test.idis@icloud.com",
      firstname: "Test",
      lastname: "Idis" }).model }

  let (:unconfirmed) { User::Create::Unconfirmed.(
    user: {
      email: "unconfirmed@icloud.com",
      firstname: "Test",
      lastname: "Idis" }).model }

    let (:unconfirmed_sleeping) { User::Create::Unconfirmed::Sleeping.(
    user: {
      email: "unconfirmed_sleeping@icloud.com",
      firstname: "Test",
      lastname: "Idis" }).model }

  let (:confirmed) { User::Create::Confirmed.(
    user: {
      email: "confirmed@icloud.com",
      firstname: "Test",
      lastname: "Idis" }).model }

  let (:confirmed_sleeping) { User::Create::Confirmed::Sleeping.(
    user: {
      email: "confirmed_sleeping@icloud.com",
      firstname: "Test",
      lastname: "Idis" }).model }

  let (:admin) { User::Create::Confirmed::Admin.(
    user: {
      email: "admin@clubbccex.com",
      firstname: "Admin",
      lastname: "Istrator"}).model }



  describe "User::Create" do
    it "persists valid" do
      expect(valid_user.persisted?).to be_truthy
      expect(valid_user.firstname).to eq "Test"
      expect(valid_user.lastname).to eq "Idis"
      expect(valid_user.email).to eq "test.idis@icloud.com"
    end
  end

  describe "User::Create::Unconfirmed" do
    it do
      expect(unconfirmed.persisted?).to be_truthy
      expect(unconfirmed.confirmed).to eq 0
      expect(unconfirmed.sleeping).to eq 0
      expect(unconfirmed.auth_meta_data).to eq nil
    end
  end

  describe "User::Create::Unconfirmed::Sleeping" do
    it do
      expect(unconfirmed_sleeping.persisted?).to be_truthy
      expect(unconfirmed_sleeping.confirmed).to eq 0
      expect(unconfirmed_sleeping.sleeping).to eq 1
      expect(unconfirmed.auth_meta_data).to eq nil
    end
  end

  describe "User::Create::Confirmed" do
    it do
      expect(confirmed.persisted?).to be_truthy
      expect(confirmed.confirmed).to eq 1
      expect(confirmed.sleeping).to eq 0
      expect(Tyrant::Authenticatable.new(confirmed).digest).to eq "password"
    end
  end

  describe "User::Create::Confirmed::Sleeping" do
    it do
      expect(confirmed_sleeping.persisted?).to be_truthy
      expect(confirmed_sleeping.confirmed).to eq 1
      expect(confirmed_sleeping.sleeping).to eq 1
      expect(Tyrant::Authenticatable.new(confirmed_sleeping).confirmable?).to be_truthy
    end
  end

  describe "User::Create::Confirmed::Admin" do
    it do
      expect(admin.persisted?).to be_truthy
      expect(admin.confirmed).to eq 1
      expect(admin.sleeping).to eq 0
      expect(admin.admin).to be_truthy
      expect(Tyrant::Authenticatable.new(admin).digest).to eq "password"
    end
  end
end
