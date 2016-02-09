require 'rails_helper'

RSpec.describe Post::Create, type: :operation do
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

  context "valid" do
    it "renders form" do
      form = Post::Create.present({current_user: user}).contract

      expect(form.title).to be_nil
      expect(form.body).to be_nil
    end

    it "persists post" do
      res, op = Post::Create.run(post: {
        title: "Un titre",
        body: "Lorem Ipsum",
        category: { "id" => category.id }
      },
      current_user: user)

      expect(res).to be_truthy
      expect(op.model.persisted?).to be_truthy
    end
  end

  context "invalid" do
    it "with no signed in user" do
      expect{Post::Create.run({})}.to raise_error{ Trailblazer::NotAuthorizedError }
    end

    it "with no title" do
      res, op = Post::Create.run(post: {title: "", body: "Lorem Ipsum", category: { "id" => category.id}}, current_user: user)

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:title=>[\"doit être rempli(e)\", \"est trop court (au moins 4 caractères)\"]}"
    end

    it "with title too short" do
      res, op = Post::Create.run(post: {title: "123", body: "Lorem Ipsum", category: { "id" => category.id}}, current_user: user)

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:title=>[\"est trop court (au moins 4 caractères)\"]}"
    end

    it "with no category" do
      res, op = Post::Create.run(post: {title: "titre", body: "Lorem Ipsum"}, current_user: user)

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:category=>[\"doit être rempli(e)\"]}"
    end

    it "with wrong category id" do
      expect { Post::Create.run(
        post: {
          title: "titre", 
          body: "Lorem Ipsum", 
          category: { "id" => "wrong" } }, 
        current_user: user) 
      }.to raise_error ActiveRecord::RecordNotFound
    end

    it "with no description" do
      res, op = Post::Create.run(post: {title: "titre", body: "", category: { "id" => category.id}}, current_user: user)

      expect(res).to be_falsey
      expect(op.errors.to_s).to eq "{:body=>[\"doit être rempli(e)\"]}"
    end
  end
end
