require 'rails_helper'

RSpec.describe Recommendation do
  describe Recommendation::Confirm, type: :operation do
    let(:valid_user) { User::Create.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com",
      recommenders: [
        {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
        {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
      ]}).model }
    
    before(:example) do
      valid_user
      recommendation = Recommendation.first
    end

    it "renders form" do
      recommendation = Recommendation.first
      form = Recommendation::Confirm.present(recommendation).contract
      form.prepopulate!

      expect(form.confirmed).to be_falsey
    end
  end
end

