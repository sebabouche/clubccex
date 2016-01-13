require 'test_helper'

class RecommendationOperationTest < MiniTest::Spec
  describe "Recommendation::Confirm" do
    let(:valid_user) { User::Create.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com",
      recommenders: [
        {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
        {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
      ]}).model }

    it "renders form" do
      recommendation = Recommendation.first
      form = Recommendation::Confirm.present(recommendation).contract
      form.prepopulate!

      form.confirmed.must_equal nil
    end
  end
end
