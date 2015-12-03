require 'rails_helper'

RSpec.describe User do
  describe User::Create, type: :operation do

    let(:valid_user) { User::Create.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com",
      recommenders: [
        {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
        {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
      ]}).model }

    it "renders form" do
      form = User::Create.present({}).contract
      form.prepopulate!

      expect(form.recommenders.size).to eq(2)
      expect(form.recommenders[0].email).to be_nil
      expect(form.recommenders[1].email).to be_nil
    end


    context "is valid and persists" do
      it "with valid user infos" do
        expect(valid_user.persisted?).to be_truthy
        expect(valid_user.firstname).to eq 'Sébastien'
        expect(valid_user.lastname).to eq 'Nicolaïdis'
        expect(valid_user.email).to eq 's.nicolaidis@me.com'
      end

      it "with an existing recommender" do
        test_idis = User.create(firstname: "Test", lastname: "Idis", email: "test.idis@icloud.com")
        expect(User.count).to eq(1)

        op = User::Create.(user: {
        firstname: "Sébastien",
        lastname: "Nicolaïdis",
        email: "s.nicolaidis@me.com",
        recommenders: [
          {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
        ]})

        expect(User.count).to eq(3)
        expect(op.model.recommenders[0].attributes.slice("id", "email")).to eq("id" => test_idis.id, "email" => "test.idis@icloud.com")
      end 
      
      it "with existing recommender and doesn't change recommender's firstname" do
        test_idis = User.create(firstname: "Test", lastname: "Idis", email: "test.idis@icloud.com")
        expect(User.count).to eq(1)

        op = User::Create.(user: {
        firstname: "Sébastien",
        lastname: "Nicolaïdis",
        email: "s.nicolaidis@me.com",
        recommenders: [
          {"firstname" => "Tesssssst", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
        ]})

        expect(User.count).to eq(3)
        expect(op.model.recommenders[0].attributes.slice("id", "firstname", "email")).to eq(
          "id" => test_idis.id, 
          "firstname" => test_idis.firstname,
          "email" => test_idis.email)
      end

    end


    context "is invalid" do
      it "without a firstname" do
        res, op = User::Create.run(user: {firstname: "", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "firstname"
      end

      it "without a lastname" do
        res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "lastname"
      end

      it "without an email" do
        res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "email"
      end

      it "without a valid email" do
        res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "blah",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to match "email"
      end

      it "with not enough recommenders" do
        res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.comé"})

        expect(res).to be_falsey
        expect(op.contract.errors.to_s).to eq "{:user=>[\"Vous devez spécifier deux recommandations différentes\"]}"
      end

      it "with an invalid recommender" do
        res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
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
    end


    it "is invalid if the recommenders are the same" do
      res, op = User::Create.run(user: {
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
end
