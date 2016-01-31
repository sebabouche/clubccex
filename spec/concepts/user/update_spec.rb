require 'rails_helper'

RSpec.describe User::Update, type: :operation do 
  let (:user) { User::Create::Confirmed.(user: {
    firstname: "Sébastien",
    lastname: "Nicolaïdis",
    email: "s.nicolaidis@me.com"}).model }
  let (:other_user) { User::Create::Confirmed.(user: {
    firstname: "Matthieu",
    lastname: "Vetter",
    email: "mattvett@gmail.com"}).model }

  describe "Users" do
    it "persists valid" do
      res, op = User::Update.run(id: user.id, user: {
        firstname: "Fille",
        lastname: "Courseuse",
        email: "fille@cce.com",
        nickname: "Nickname",
        maidenname: "Maiden",
        company: "Company",
        occupation: "Occupation",
        events: [
          {"number" => "32"},
          {"number" => "33"}
        ],
        city: "Paris",
        admin: true
      },
      current_user: user)

      expect(res).to be_truthy

      model = op.model
      expect(model.firstname).to eq "Fille"
      expect(model.lastname).to eq "Courseuse"
      expect(model.email).to eq "fille@cce.com"
      expect(model.nickname).to eq "Nickname"
      expect(model.maidenname).to eq "Maiden"
      expect(model.company).to eq "Company"
      expect(model.occupation).to eq "Occupation"
      expect(model.events[0].number).to eq 32
      expect(model.events[1].number).to eq 33
      expect(model.city).to eq "Paris"
      expect(model.admin).to be_falsey
    end
    
    it "is invalid if other user" do
      expect{
        User::Update.run(
          id: user.id, 
          user: {firstname: "Other"},
          current_user: other_user)
      }.to raise_error Trailblazer::NotAuthorizedError
    end
  end
end
