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

    it "rendering" do
      form = User::Create.present({}).contract
      form.prepopulate!

      expect(form.recommenders.size).to eq(2)
      expect(form.recommenders[0].email).to be_nil
      expect(form.recommenders[1].email).to be_nil
    end

    it "persists valid user" do
      expect(valid_user.persisted?).to be_truthy
      expect(valid_user.firstname).to eq 'Sébastien'
      expect(valid_user.lastname).to eq 'Nicolaïdis'
      expect(valid_user.email).to eq 's.nicolaidis@me.com'
    end

    it "is invalid without a firstname" do
      res, op = User::Create.run(user: {firstname: "", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
                            recommenders: [
                              {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                              {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

      expect(res).to be_falsey
      expect(op.contract.errors.to_s).to eq "{:firstname=>[\"can't be blank\"]}"
    end

    it "is invalid without a lastname" do
      res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "", email: "s.nicolaidis@me.com",
                            recommenders: [
                              {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                              {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

      expect(res).to be_falsey
      expect(op.contract.errors.to_s).to eq "{:lastname=>[\"can't be blank\"]}"
    end

    it "is invalid without an email" do
      res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "",
                            recommenders: [
                              {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                              {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

      expect(res).to be_falsey
      expect(op.contract.errors.to_s).to eq "{:email=>[\"can't be blank\", \"is invalid\"]}"
    end

    it "is invalid without a valid email" do
      res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "blah",
                            recommenders: [
                              {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                              {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

      expect(res).to be_falsey
      expect(op.contract.errors.to_s).to eq "{:email=>[\"is invalid\"]}"
    end

    it "is invalid if not enough recommenders" do
      res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.comé"})

      expect(res).to be_falsey
      expect(op.contract.errors.to_s).to eq "{:user=>[\"Not enough recommenders\"]}"
    end

    it "is invalid with an invalid recommender" do
      res, op = User::Create.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
                            recommenders: [
                              {"firstname" => "", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                              {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})


      expect(res).to be_falsey
      expect(op.contract.errors.to_s).to eq "{:\"recommenders.firstname\"=>[\"can't be blank\"]}"

      form = op.contract
      form.prepopulate!

      expect(form.recommenders[0].firstname).to eq ""
      expect(form.recommenders[1].firstname).to eq "Hack"
    end

    it "persists valid user with existing recommender" do
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
    
    it "persists valid user with existing recommender only with email" do
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
end
