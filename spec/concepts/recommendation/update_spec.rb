require 'rails_helper'

RSpec.describe Recommendation::Update, type: :operation do
  let(:user) { Session::SignUp.(user: {
    firstname: "Sébastien",
    lastname: "Nicolaïdis",
    email: "s.nicolaidis@me.com",
    recommenders: [
      {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
      {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
    ]}).model }
  let (:admin) { User::Create::Confirmed::Admin.(user: {
    firstname: "Admin",
    lastname: "Istrator",
    email: "admin@clubccex.com" }).model }

  context "Admin" do
    it "renders form" do
      user
      form = Recommendation::Update.present({id: Recommendation.first.id, current_user: admin}).contract
      form.prepopulate!

      expect(form.confirmed).to be_falsey
    end

    it "persists recommendation" do
      user
      reco_1 = Recommendation.first
      reco_2 = Recommendation.last

      #first recommendation
      res1, op1 = Recommendation::Update.run(id: reco_1.id, recommendation: { confirmed: true }, current_user: admin)
      reco1 = op1.model

      expect(res1).to be_truthy
      user = User.find(op1.model.user.id)

      expect(reco1.confirmed).to be_truthy
      expect(user.confirmed).to eq 0
      expect(user.sleeping).to eq 0

      # second recommendation
      res2, op2 = Recommendation::Update.run(id: reco_2.id, recommendation: { confirmed: true }, current_user: admin)
      reco2 = op2.model

      expect(res2).to be_truthy
      user = User.find(op2.model.user.id)

      expect(reco2.confirmed).to be_truthy
      expect(user.confirmed).to eq 1
      expect(user.sleeping).to eq 1
    end
  end

  context "Signed In" do
    before do
      User::Confirm.(id: user.id, current_user: admin)
      # Session::WakeUp.(session
    end

    it "renders form" do
      pending
    end


  end
    
end
