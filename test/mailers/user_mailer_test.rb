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
   
  ### USER ###
  test "welcome_unconfirmed" do
    email = UserMailer.welcome_unconfirmed(user.id).deliver_now

    assert_equal ActionMailer::Base.deliveries.count, 1
    assert_equal ['contact@clubccex.com'], email.from
    assert_equal ['s.nicolaidis@me.com'], email.to
    assert_equal "[CCEx] Merci de t'être enregistré(e).", email.subject
  end

  test "sign_up" do
    email = UserMailer.sign_up(user.id).deliver_now

    assert_equal ActionMailer::Base.deliveries.count, 1
    assert_equal ['contact@clubccex.com'], email.from
    assert_equal ['s.nicolaidis@me.com'], email.to
    assert_equal "[CCEx] Rejoins le club business des anciens courseux.", email.subject
  end

  ### RECOMMENDER ###
  
  test "sign_up_recommender" do
    email = UserMailer.sign_up_recommender(recommender.id, user.id).deliver_now

    assert_equal ActionMailer::Base.deliveries.count, 1
    assert_equal ['contact@clubccex.com'], email.from
    assert_equal ['abarbelet@gmail.com'], email.to
    assert_equal "[CCEx] Rejoins les anciens courseux et confirme que Sébastien Nicolaïdis en fait partie.", email.subject
  end

  test "wake_up_reminder" do
    email = UserMailer.wake_up_reminder(recommender.id, user.id).deliver_now

    assert_equal ActionMailer::Base.deliveries.count, 1
    assert_equal ['contact@clubccex.com'], email.from
    assert_equal ['abarbelet@gmail.com'], email.to
    assert_equal "[CCEx] Sébastien Nicolaïdis attend ta confirmation, rejoins-nous !", email.subject
  end
  
  test "confirm_user" do
    email = UserMailer.confirm_user(recommender.id, user.id).deliver_now

    assert_equal ActionMailer::Base.deliveries.count, 1
    assert_equal ['contact@clubccex.com'], email.from
    assert_equal ['abarbelet@gmail.com'], email.to
    assert_equal "[CCEx] Confirmes-tu que Sébastien Nicolaïdis fait partie des anciens ?", email.subject
  end

end
