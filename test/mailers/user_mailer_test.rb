require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  let (:user) { User::Create::Unconfirmed.(user: {
    firstname: "Sébastien",
    lastname: "Nicolaïdis",
    email: "s.nicolaidis@me.com" }).model }
  let (:recommender) { User::Create::Confirmed.(user: {
    firstname: "Arnaud",
    lastname: "Barbelet",
    email: "abarbelet@gmail.com" }).model }
    
  test "welcome_unconfirmed" do
    email = UserMailer.welcome_unconfirmed(user).deliver_now

    assert_equal ActionMailer::Base.deliveries.count, 1
    assert_equal ['contact@clubccex.com'], email.from
    assert_equal ['s.nicolaidis@me.com'], email.to
  end
end
