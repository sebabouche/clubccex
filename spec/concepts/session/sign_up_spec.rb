require 'rails_helper'

RSpec.describe Session::SignUp, type: :operation do
  describe "SignUp" do

    let(:valid_user) { Session::SignUp.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com",
      recommenders: [
        {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
        {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
      ]}).model }

    it "renders form" do
      form = Session::SignUp.present({}).contract
      form.prepopulate!

      expect(form.recommenders.size).to eq (2)
      expect(form.recommenders[0].email).to eq nil
      expect(form.recommenders[1].email).to eq nil
    end


    describe "is valid and persists" do
      it "with valid user infos" do
        expect(valid_user.persisted?).to be_truthy
        expect(valid_user.firstname).to eq 'Sébastien'
        expect(valid_user.lastname).to eq 'Nicolaïdis'
        expect(valid_user.email).to eq 's.nicolaidis@me.com'
        expect(valid_user.confirmed).to eq 0
        expect(valid_user.sleeping).to eq 0

      end

      it "with an existing recommender" do
        test_idis = User.create(firstname: "Test", lastname: "Idis", email: "test.idis@icloud.com")

        op = Session::SignUp.(user: {
        firstname: "Sébastien",
        lastname: "Nicolaïdis",
        email: "s.nicolaidis@me.com",
        recommenders: [
          {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
        ]})

        expect(op.model.recommenders[0].attributes.slice("id", "email")).to eq "id" => test_idis.id, "email" => "test.idis@icloud.com"
      end
      
      it "with existing recommender and doesn't change recommender's firstname" do
        test_idis = User.create(firstname: "Test", lastname: "Idis", email: "test.idis@icloud.com")
        
        op = Session::SignUp.(user: {
        firstname: "Sébastien",
        lastname: "Nicolaïdis",
        email: "s.nicolaidis@me.com",
        recommenders: [
          {"firstname" => "Tesssssst", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
        ]})

        expect(User.count).to eq 3
        expect(op.model.recommenders[0].attributes.slice("id", "firstname", "email")).to eq "id" => test_idis.id, "firstname" => test_idis.firstname, "email" => test_idis.email
      end
    end


    describe "is invalid" do
      it "without a firstname" do
        res, op = Session::SignUp.run(user: {firstname: "", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "firstname"
      end

      it "without a lastname" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "lastname"
      end

      it "without an email" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "email"
      end

      it "without a valid email" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "blah",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "email"
      end

      it "if email is already taken" do
        previous = User::Create.(user: {firstname: "Previous", lastname: "User", email: "previous@user.com"}).model

        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: previous.email,
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "email"
      end

      it "with not enough recommenders" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.comé"})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "user"
      end

      it "with an invalid recommender" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})


        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "recommenders.firstname"

        form = op.contract
        form.prepopulate!

        expect(form.recommenders[0].firstname).to eq ""
        expect(form.recommenders[1].firstname).to eq "Hack"
      end

      it "if the recommenders are the same" do
        res, op = Session::SignUp.run(user: {
          firstname: "Sébastien",
          lastname: "Nicolaïdis",
          email: "s.nicolaidis@me.com",
          recommenders: [
            {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
            {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"}
          ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to eq "{:user=>[\"Vous devez spécifier deux recommandations différentes\"]}"
      end
    end

    describe "Mailers" do
      it "sends 3 emails with two unconfirmed" do
        valid_user
        expect(ActionMailer::Base.deliveries.count).to eq 3
      end

      it "sends 3 emails with two confirmed" do
        confirmed1 = User::Create::Confirmed.(user: {
          firstname: "Sébastien",
          lastname: "Unconfirmed",
          email: "s.nicolaidis@me.com"}).model

        confirmed2 = User::Create::Confirmed.(user: {
          firstname: "Arnaud",
          lastname: "Confirmed",
          email: "abarbelet@gmail.com"}).model

        op = Session::SignUp.(user: {
          firstname: "Matthieu",
          lastname: "Vetter",
          email: "mattvett@gmail.com",
          recommenders: [
            {"firstname" => confirmed1.firstname, "lastname" => confirmed1.lastname, "email" => confirmed1.email},
            {"firstname" => confirmed2.firstname, "lastname" => confirmed2.lastname, "email" => confirmed2.email}
          ]})

        expect(ActionMailer::Base.deliveries.count).to eq 3
      end

      it "sends 3 emails with one confirmed and one confirmed_sleeping" do
        confirmed1 = User::Create::Confirmed::Sleeping.(user: {
          firstname: "Sébastien",
          lastname: "Unconfirmed",
          email: "s.nicolaidis@me.com"}).model

        confirmed2 = User::Create::Confirmed.(user: {
          firstname: "Arnaud",
          lastname: "Confirmed",
          email: "abarbelet@gmail.com"}).model

        op = Session::SignUp.(user: {
          firstname: "Matthieu",
          lastname: "Vetter",
          email: "mattvett@gmail.com",
          recommenders: [
            {"firstname" => confirmed1.firstname, "lastname" => confirmed1.lastname, "email" => confirmed1.email},
            {"firstname" => confirmed2.firstname, "lastname" => confirmed2.lastname, "email" => confirmed2.email}
          ]})

        expect(ActionMailer::Base.deliveries.count).to eq 3 
      end


      it "sends 2 emails with one unknown and one unconfirmed" do
        unconfirmed = User::Create::Unconfirmed.(user: {
          firstname: "Sébastien",
          lastname: "Unconfirmed",
          email: "s.nicolaidis@me.com"}).model

        confirmed = User::Create::Confirmed.(user: {
          firstname: "Arnaud",
          lastname: "Confirmed",
          email: "abarbelet@gmail.com"}).model

        op = Session::SignUp.(user: {
          firstname: "Matthieu",
          lastname: "Vetter",
          email: "mattvett@gmail.com",
          recommenders: [
            {"firstname" => unconfirmed.firstname, "lastname" => unconfirmed.lastname, "email" => unconfirmed.email},
            {"firstname" => confirmed.firstname, "lastname" => confirmed.lastname, "email" => confirmed.email}
          ]})

        expect(ActionMailer::Base.deliveries.count).to eq 2
      end
    end

    describe "Admin field" do
      it "is invalid if an admin field" do
        res, op = Session::SignUp.run(user: {
          firstname: "Sébastien",
          lastname: "Nicolaïdis",
          email: "s.nicolaidis@me.com",
          admin: true,
          recommenders: [
            {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
            {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"}
          ]})

        expect(res).to be_falsey
      end
    end
  end
end
