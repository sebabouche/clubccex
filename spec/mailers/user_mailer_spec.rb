require "rails_helper"

RSpec.describe UserMailer do
  before do
    user = Session::SignUp.(user: {
    firstname: "Sébastien",
    lastname: "Nicolaïdis",
    email: "s.nicolaidis@me.com",
    recommenders: [
      { "firstname" => "Arnaud", "lastname" => "Barbelet", "email" => "arnaud@clubccex.com"},
      { "firstname" => "Matt", "lastname" => "Vetter", "email" => "matthieu@clubccex.com"} ] }).model
    admin = User::Create::Confirmed::Admin.(user: {firstname: "A", lastname: "A", email: "admin@clubccex.com"})
    User::Confirm.(id: user.recommenders[0].id, current_user: admin)
    User::Confirm.(id: user.recommenders[1].id, current_user: admin)
  end

  let (:user) { User.find_by_email("s.nicolaidis@me.com") }
  let (:recommender) { User.find_by_email("arnaud@clubccex.com") }   

  context "User" do
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
  end

  context "Recommender" do
    describe "sign_up_recommender" do
      let(:email) { UserMailer.sign_up_recommender(recommender.id, user.id) }

      it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
      it { expect(email.from).to eq ['contact@clubccex.com'] }
      it { expect(email.to).to eq ['arnaud@clubccex.com'] }
      it { expect(email.subject).to eq "[CCEx] Rejoins les anciens courseux et confirme que Sébastien Nicolaïdis en fait partie." }
    end

    describe "wake_up_reminder" do
      let(:email) { UserMailer.wake_up_reminder(recommender.id, user.id) }

      it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
      it { expect(email.from).to eq ['contact@clubccex.com'] }
      it { expect(email.to).to eq ['arnaud@clubccex.com'] }
      it { expect(email.subject).to eq "[CCEx] Sébastien Nicolaïdis attend ta confirmation, rejoins-nous !" }
    end
    
    describe "confirm_user" do
      let(:email) { UserMailer.confirm_user(recommender.id, user.id) }

      it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
      it { expect(email.from).to eq ['contact@clubccex.com'] }
      it { expect(email.to).to eq ['arnaud@clubccex.com'] }
      it { expect(email.subject).to eq "[CCEx] Confirmes-tu que Sébastien Nicolaïdis fait partie des anciens ?" }
      it { expect(email.body).to match "<a href=\"http://localhost:3000/recommendations/#{Recommendation.find_by_user_id_and_recommender_id!(user.id, recommender.id).id}/edit\">" }
    end
  end

  context "Comment" do
    let(:admin) { User::Create::Confirmed::Admin.(user: {firstname: "Admin", lastname: "Strator", email: "admin@example.com"}).model }
    let(:category) { Category::Create.(category: {name: "Jobs", priority: 1}, current_user: admin).model }
    let(:post) { Post::Create.(post: {title: "Titre", body: "Lorem Ipsum", category_id: category.id}, current_user: admin).model }
    let(:comment) { Comment::Create.(comment: {body: "Awesome!", post: post}, current_user: recommender).model }

    describe "notify_comment" do
      let(:email) { UserMailer.notify_comment(comment.id) }

      it { expect{email.deliver_now!}.to change{ActionMailer::Base.deliveries.count}.by 1 }
      it { expect(email.from).to eq ['contact@clubccex.com'] }
      it { expect(email.to).to eq ["#{admin.email}"] }
      it { expect(email.subject).to eq "[CCEx] Arnaud Barbelet a commenté un post que vous avez écrit." }
      it { expect(email.body).to match "<a href=\"http://localhost:3000/posts/#{post.id}\">Voir le post et ses commentaires</a>" }

    end
  end
end
