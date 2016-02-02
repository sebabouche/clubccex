require 'rails_helper'

RSpec.describe Comment::Create, type: :operation do
  let (:admin) { User::Create::Confirmed::Admin.(user: {
    firstname: "Admin",
    lastname: "Istrator",
    email: "admin@clubccex.com" }).model }
  let(:category) { Category::Create.(category: {
      priority: 1,
      name: "Jobs"
    },
    current_user: admin).model }
  let (:user) { User::Create::Confirmed.(user: {
    firstname: "Seb",
    lastname: "Nico",
    email: "seb@example.com" }).model }
  let (:post) { Post::Create.(
    current_user: user,
    post: {
      title: "Titre",
      body: "Lorem Ipsum",
      category_id: category.id}).model }

  context "valid" do
    it "renders form" do
      form = Comment::Create.present({id: post.id, current_user: user}).contract

      expect(form.body).to be_nil
    end

    it "persists valid" do
      res, op = Comment::Create.run(
        id: post.id,
        current_user: user,
        comment: { body: "A great comment." })

      expect(res).to be_truthy
      expect(op.model.persisted?).to be_truthy
      expect(op.model.body).to eq "A great comment."
    end
  end

  context "invalid" do
    it "raises error if not signed in" do
      expect{ 
        Comment::Create.run(id: post.id, comment: { body: "A comment." }) 
      }.to raise_error{ Trailblazer::NotAuthorizedError }
    end
    
    it "needs a post id" do
      res, op = Comment::Create.run(current_user: user, comment: { body: "A comment."})

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:post=>[\"doit être rempli(e)\"]}"
    end

    it "needs a body" do
      res, op = Comment::Create.run(id: post.id, current_user: user, comment: { body: ""})

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:body=>[\"est trop court (au moins 6 caractères)\", \"doit être rempli(e)\"]}"
    end

    it "needs a body longer than x chars" do
      res, op = Comment::Create.run(id: post.id, current_user: user, comment: { body: "12345"})

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:body=>[\"est trop court (au moins 6 caractères)\"]}"
    end

    it "needs a body not too longer than x chars" do
      message = "aha" * 100
      res, op = Comment::Create.run(id: post.id, current_user: user, comment: { body: message})

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:body=>[\"est trop long (pas plus de 160 caractères)\"]}"
    end
  end

  context "notification" do
    it "sends notification" do
      expect{ Comment::Create.run(
        id: post.id, 
        current_user: admin, 
        comment: { body: "A comment." }) }.to change{ ActionMailer::Base.deliveries.count }.by 1
    end

    it "doesn't send notification if commenter is OP" do
      expect{ Comment::Create.run(
        id: post.id,
        current_user: user,
        comment: { body: "A comment." }) }.to_not change{ ActionMailer::Base.deliveries.count }
    end
  end
end

