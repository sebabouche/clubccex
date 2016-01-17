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
