require 'test_helper'

class UserCreateTest < MiniTest::Spec
  let (:valid_user) { User::Create.(
    user: {
      email: "test.idis@icloud.com",
      firstname: "Test",
      lastname: "Idis" }).model }

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


  describe "User::Create" do
    it "persists valid" do
      valid_user.persisted?.must_equal true
      valid_user.firstname.must_equal "Test"
      valid_user.lastname.must_equal "Idis"
      valid_user.email.must_equal "test.idis@icloud.com"
    end
  end

  describe "User::Create::Unconfirmed" do
    it do
      unconfirmed.persisted?.must_equal true
      unconfirmed.confirmed.must_equal 0
      unconfirmed.sleeping.must_equal 0
    end
  end

  describe "User::Create::Unconfirmed::Sleeping" do
    it do
      unconfirmed_sleeping.persisted?.must_equal true
      unconfirmed_sleeping.confirmed.must_equal 0
      unconfirmed_sleeping.sleeping.must_equal 1
    end
  end

  describe "User::Create::Confirmed" do
    it do
      confirmed.persisted?.must_equal true
      confirmed.confirmed.must_equal 1
      confirmed.sleeping.must_equal 0
    end
  end

  describe "User::Create::Confirmed::Sleeping" do
    it do
      confirmed_sleeping.persisted?.must_equal true
      confirmed_sleeping.confirmed.must_equal 1
      confirmed_sleeping.sleeping.must_equal 1
    end
  end
end