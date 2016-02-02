require 'rails_helper'

RSpec.describe Post::Update, type: :operation do
  let (:user) { User::Create::Confirmed.(user: {
    firstname: "Seb",
    lastname: "Nico",
    email: "seb@example.com" }).model }
  let (:post) { Post::Create.(post: {
      title: "Un titre",
      body: "Lorem Ipsum",
      category_id: category.id },
    current_user: user).model }
  let (:admin) { User::Create::Confirmed::Admin.(user: {
    firstname: "Admin",
    lastname: "Istrator",
    email: "admin@clubccex.com" }).model }
  let(:category) { Category::Create.(category: {
      priority: 1,
      name: "Jobs"
    },
    current_user: admin).model }

  context "valid" do
    it "renders form" do
      form = Post::Update.present({id: post.id, current_user: user}).contract

      expect(form.title).to eq post.title
      expect(form.body).to eq post.body
    end

    it "persists valid" do
      res, op = Post::Update.run(
        id: post.id,
        post: {
          title: "Another title",
          body: "Another body",
          category_id: "sdfsdfsdf",
          user_id: "sdfsdfsdf",
          closed: true },
        current_user: user)

      expect(res).to be_truthy
      expect(op.model.title).to eq "Another title"
      expect(op.model.body).to eq "Another body"
      expect(op.model.closed).to be_truthy
      expect(op.model.user).to eq user
      expect(op.model.category).to eq category
    end
  end

  context "invalid" do
    it "can't be updated by someone else" do
      expect{ Post::Update.run( id: post.id, post: { title: "Another title" }, current_user: admin) 
        }.to raise_error Trailblazer::NotAuthorizedError
    end
  end
end
