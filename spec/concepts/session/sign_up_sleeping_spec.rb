require 'rails_helper'

RSpec.describe Session::SignUp::Sleeping, type: :operation do
  describe "SignUpSleeping" do

    let (:sleeping_user) { User::Create::Unconfirmed::Sleeping.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com"}).model }

    it "is unconfirmed and sleeping" do
      expect(sleeping_user.confirmed).to eq 0
      expect(sleeping_user.sleeping).to eq 1
    end

    it "renders form" do
      form = Session::SignUp::Sleeping.present({id: sleeping_user.id}).contract
      form.prepopulate!

      expect(form.recommenders.size).to eq (2)
      expect(form.firstname).to eq sleeping_user.firstname
      expect(form.lastname).to eq sleeping_user.lastname
      expect(form.email).to eq sleeping_user.email

      expect(form.recommenders[0].email).to be_falsey
      expect(form.recommenders[1].email).to be_falsey
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

      expect(res).to be_truthy

      expect(user.persisted?).to be_truthy
      expect(user.firstname).to eq 'Sébastien'
      expect(user.lastname).to eq 'Nicolaïdis'
      expect(user.email).to eq 's.nicolaidis@me.com'
      expect(user.confirmed).to eq 0
      expect(user.sleeping).to eq 0
    end
  end
end
