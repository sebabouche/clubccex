require "rails_helper"

RSpec.describe UserMailer do
  let (:user) { User::Create::Unconfirmed.(user: {
    firstname: "Sébastien",
    lastname: "Nicolaïdis",
    email: "s.nicolaidis@me.com" }).model }
  let (:recommender) { User::Create::Confirmed.(user: {
    firstname: "Arnaud",
    lastname: "Barbelet",
    email: "abarbelet@gmail.com" }).model }
   
  ### USER ###
  describe "welcome_unconfirmed" do
    let(:email) { UserMailer.welcome_unconfirmed(user.id) }

    it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
    it { expect(email.from).to eq ['contact@clubccex.com'] }
    it { expect(email.to).to eq ['s.nicolaidis@me.com'] }
    it { expect(email.subject).to eq "[CCEx] Merci de t'être enregistré(e)." }
  end

  describe "sign_up" do
    let(:email) { UserMailer.sign_up(user.id) }

    it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
    it { expect(email.from).to eq ['contact@clubccex.com'] }
    it { expect(email.to).to eq ['s.nicolaidis@me.com'] }
    it { expect(email.subject).to eq "[CCEx] Rejoins le club business des anciens courseux." }
  end

  ### RECOMMENDER ###
  
  describe "sign_up_recommender" do
    let(:email) { UserMailer.sign_up_recommender(recommender.id, user.id) }

    it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
    it { expect(email.from).to eq ['contact@clubccex.com'] }
    it { expect(email.to).to eq ['abarbelet@gmail.com'] }
    it { expect(email.subject).to eq "[CCEx] Rejoins les anciens courseux et confirme que Sébastien Nicolaïdis en fait partie." }
  end

  describe "wake_up_reminder" do
    let(:email) { UserMailer.wake_up_reminder(recommender.id, user.id) }

    it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
    it { expect(email.from).to eq ['contact@clubccex.com'] }
    it { expect(email.to).to eq ['abarbelet@gmail.com'] }
    it { expect(email.subject).to eq "[CCEx] Sébastien Nicolaïdis attend ta confirmation, rejoins-nous !" }
  end
  
  describe "confirm_user" do
    let(:email) { UserMailer.confirm_user(recommender.id, user.id) }

    it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
    it { expect(email.from).to eq ['contact@clubccex.com'] }
    it { expect(email.to).to eq ['abarbelet@gmail.com'] }
    it { expect(email.subject).to eq "[CCEx] Confirmes-tu que Sébastien Nicolaïdis fait partie des anciens ?" }
  end
end
