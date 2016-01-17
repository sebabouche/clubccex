require 'test_helper'

class UserConfirmTest < MiniTest::Spec
  let(:user) { Session::SignUp.(user: {
    firstname: "Sébastien",
    lastname: "Nicolaïdis",
    email: "s.nicolaidis@me.com",
    recommenders: [
      {"firstname" => "Arnaud", "lastname" => "Barbelet", "email" => "abarbelet@gmail.com"},
      {"firstname" => "Matthieu", "lastname" => "Vetter", "email" => "mattvett@gmail.com"}
    ]
  }).model }

  describe "User::Confirm" do
    it "confirm" do

      res, op = User::Confirm.run(id: user.id)
      user = op.model

      res.must_equal true

      user.confirmed.must_equal 1
      user.sleeping.must_equal 1
      user.auth_meta_data.to_s.must_match "confirmation_token"
      ActionMailer::Base.deliveries.count.must_equal 4
    end
  end

  describe "User::Confirm::Admin" do
    let (:admin) { User::Create::Confirmed::Admin.(user: {
      firstname: "Admin",
      lastname: "Istrator",
      email: "admin@clubccex.com" }).model }
    let (:unconfirmed) { User::Create::Unconfirmed.(user: {
      firstname: "Unconfirmed",
      lastname: "Unconfirmed",
      email: "unconfirmed@unconfirmed.com"}).model }
    let (:confirmed) { User::Create::Confirmed.(user: {
      firstname: "Confirmed",
      lastname: "Confirmed",
      email: "confirmed@confirmed.com" }).model }

    it "is valid when admin" do
      res, op = User::Confirm::Admin.run(
        id: unconfirmed.id,
        current_user: admin)

      res.must_equal true
      user = op.model

      user.confirmed.must_equal 1
      user.sleeping.must_equal 1
      user.auth_meta_data.to_s.must_match "confirmation_token"
      ActionMailer::Base.deliveries.count.must_equal 1
    end

    it "is invalid when not admin" do
      assert_raises Trailblazer::NotAuthorizedError do
        User::Confirm::Admin.run(
          id: unconfirmed.id,
          current_user: confirmed)
      end
    end

    it "is invalid when not signed in" do
      assert_raises Trailblazer::NotAuthorizedError do
        User::Confirm::Admin.run(
          id: unconfirmed.id)
      end
    end

  end
end
