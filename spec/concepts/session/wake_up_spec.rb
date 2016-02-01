require 'rails_helper'

RSpec.describe Session::WakeUp, type: :operation do
  let(:valid) { User::Create::Confirmed::Sleeping.(user: {
    firstname: "Amaury",
    lastname: "Desombre",
    email: "amaury@example.com"}).model }
  let(:confirmation_token) { Tyrant::Authenticatable.new(valid).confirmation_token }

  context "with valid passwords" do
    it "renders form" do
      form = Session::WakeUp.present({id: valid.id, confirmation_token: confirmation_token }).contract
      form.prepopulate!

      expect(form.password).to eq nil
      expect(form.confirm_password).to eq nil
    end

    it "unsleeps user" do
      res, op = Session::WakeUp.run(
        id: valid.id, 
        confirmation_token: confirmation_token, 
        user: {password: "password", confirm_password: "password"}
      )

      expect(res).to be_truthy
      expect(op.model.confirmed).to eq 1
      expect(op.model.sleeping).to eq 0
    end

    it "saves password" do
      op = Session::WakeUp.(
        id: valid.id,
        confirmation_token: confirmation_token,
        user: {password: "password", confirm_password: "password"}
      )

      expect(Tyrant::Authenticatable.new(op.model).digest).to eq "password"
    end
  end

  context "with wrong password combination" do
    it "raises error with all blank fields" do
      res, op = Session::WakeUp.run(
        id: valid.id, 
        confirmation_token: confirmation_token, 
        user: {password: "", confirm_password: ""}
      )

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:password=>[\"doit être rempli(e)\"], :confirm_password=>[\"doit être rempli(e)\"]}"
    end

    it "raises error with one blank field" do
      res, op = Session::WakeUp.run(
        id: valid.id, 
        confirmation_token: confirmation_token, 
        user: {password: "password", confirm_password: ""}
      )

      expect(res).to be_falsey
      # TODO Translation for password mismatch
      expect(op.errors.to_s).to eq "{:password=>[\"Password mismatch\"], :confirm_password=>[\"doit être rempli(e)\"]}"
    end

    it "raises error with unmatching passwords" do
      res, op = Session::WakeUp.run(
        id: valid.id, 
        confirmation_token: confirmation_token, 
        user: {password: "password", confirm_password: "123123"}
      )

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:password=>[\"Password mismatch\"]}"
    end
  end
end
