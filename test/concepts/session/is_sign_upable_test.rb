require 'test_helper'

class IsSignUpableTest < MiniTest::Spec
  describe "Session::IsSignUpable" do

    let (:unconfirmed) { User::Create::Unconfirmed.(
      user: {
        email: "test.idis@icloud.com",
        firstname: "Test",
        lastname: "Idis" }).model }

      let (:unconfirmed_sleeping) { User::Create::Unconfirmed::Sleeping.(
      user: {
        email: "test.idis@icloud.com",
        firstname: "Test",
        lastname: "Idis" }).model }

    let (:confirmed) { User::Create::Confirmed.(
      user: {
        email: "test.idis@icloud.com",
        firstname: "Test",
        lastname: "Idis" }).model }

    let (:confirmed_sleeping) { User::Create::Confirmed::Sleeping.(
      user: {
        email: "test.idis@icloud.com",
        firstname: "Test",
        lastname: "Idis" }).model }

    it "is valid for Unconfirmed::Sleeping" do
      res, op = Session::IsSignUpable.run(id: unconfirmed_sleeping.id)

      res.must_equal true
    end

    it "is invalid for Unconfirmed" do
      res, op = Session::IsSignUpable.run(id: unconfirmed.id)

      res.must_equal false
    end

    it "is invalid for Confirmed" do
      res, op = Session::IsSignUpable.run(id: confirmed.id)

      res.must_equal false
    end

    it "is invalid for Confirmed::Sleeping" do
      res, op = Session::IsSignUpable.run(id: confirmed_sleeping.id)

      res.must_equal false
    end

  end
end
