require 'test_helper'

class RecommendationUpdateTest < MiniTest::Spec
  describe "Recommendation::Update" do
    let(:valid_user) { Session::SignUp.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com",
      recommenders: [
        {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
        {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
      ]}).model }

    it "renders form" do
      valid_user
      recommendation = Recommendation.first
      form = Recommendation::Update.present(recommendation).contract
      form.prepopulate!

      form.confirmed.must_equal nil
    end

    it do
      valid_user

      reco_1 = Recommendation.first
      reco_2 = Recommendation.last

      #first recommendation
      res1, op1 = Recommendation::Update.run(id: reco_1.id, recommendation: { confirmed: true })
      reco1 = op1.model

      res1.must_equal true
      user = User.find(op1.model.user.id)

      reco1.confirmed.must_equal true
      user.confirmed.must_equal 0
      user.sleeping.must_equal 0

      res2, op2 = Recommendation::Update.run(id: reco_2.id, recommendation: { confirmed: true })
      reco2 = op2.model

      res2.must_equal true
      user = User.find(op2.model.user.id)

      reco2.confirmed.must_equal true
      user.confirmed.must_equal 1
      user.sleeping.must_equal 1
    end
  end
end
