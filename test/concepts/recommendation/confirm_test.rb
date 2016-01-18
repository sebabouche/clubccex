require 'test_helper'

class RecommendationUpdateTest < MiniTest::Spec
  describe "Recommendation::Update" do
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

    it "renders form" do
      user
      recommendation = Recommendation.first
      form = Recommendation::Update.present({id: recommendation, current_user: admin}).contract
      form.prepopulate!

      form.confirmed.must_equal nil
    end

    it do
      user

      reco_1 = Recommendation.first
      reco_2 = Recommendation.last

      #first recommendation
      res1, op1 = Recommendation::Update.run(id: reco_1, recommendation: { confirmed: true }, current_user: admin)
      reco1 = op1.model

      res1.must_equal true
      user = User.find(op1.model.user.id)

      reco1.confirmed.must_equal true
      user.confirmed.must_equal 0
      user.sleeping.must_equal 0

      res2, op2 = Recommendation::Update.run(id: reco_2, recommendation: { confirmed: true }, current_user: admin)
      reco2 = op2.model

      res2.must_equal true
      user = User.find(op2.model.user.id)

      reco2.confirmed.must_equal true
      user.confirmed.must_equal 1
      user.sleeping.must_equal 1
    end
  end
end
