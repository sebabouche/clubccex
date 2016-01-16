require 'test_helper'

class SessionSignUpSleepingTest < MiniTest::Spec
  describe "SignUpSleeping" do

    let (:sleeping_user) { User::Create::Unconfirmed::Sleeping.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com"}).model }

    it "is unconfirmed and sleeping" do
      sleeping_user.confirmed.must_equal 0
      sleeping_user.sleeping.must_equal 1
    end

    it "renders form" do
      form = Session::SignUp::Sleeping.present({id: sleeping_user.id}).contract
      form.prepopulate!

      form.recommenders.size.must_equal (2)
      form.firstname.must_equal sleeping_user.firstname
      form.lastname.must_equal sleeping_user.lastname
      form.email.must_equal sleeping_user.email

      form.recommenders[0].email.must_equal nil
      form.recommenders[1].email.must_equal nil
    end

    it "persists valid" do
      sleeping_user
      res, op = Session::SignUp::Sleeping.run(id: sleeping_user.id, user: {
        firstname: sleeping_user.firstname,
        lastname: sleeping_user.lastname,
        email: sleeping_user.email,
        recommenders: [
          {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
        ]})
      user = op.model

      res.must_equal true

      user.persisted?.must_equal true
      user.firstname.must_equal 'Sébastien'
      user.lastname.must_equal 'Nicolaïdis'
      user.email.must_equal 's.nicolaidis@me.com'
      user.confirmed.must_equal 0
      user.sleeping.must_equal 0
    end
  end
end
