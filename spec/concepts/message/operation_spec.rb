require 'rails_helper'

RSpec.describe Message do

  describe Message::Create, type: :operation do
    let (:user1) { User::Create::Confirmed.(
      user: {
        email: "user1@example.com",
        firstname: "User",
        lastname: "1"}).model }
    let (:user2) { User::Create::Confirmed.(
      user: {
        email: "user2@example.com",
        firstname: "User",
        lastname: "2"}).model }
    let (:user3) { User::Create::Confirmed.(
      user: {
        email: "user3@example.com",
        firstname: "User",
        lastname: "3"}).model }
    let (:conversation) { Conversation.create }

    context "valid" do
      it "renders form" do
        form = Message::Create.present({current_user: user1}).contract

        expect(form.body).to be_nil
      end

      it "with an existing conversation" do
        user2
        user3
        res, op = Message::Create.run(
          current_user: user1,
          message: {
            body: "A message",
            conversation: conversation,
            users: [
              {"email" => "user2@example.com"},
              {"email" => "user3@example.com"}
            ]
          }
        )

        expect(res).to be_truthy
        expect(op.model.persisted?).to be_truthy
        expect(op.model.user).to eq user1
        expect(op.model.users.pluck(:id)).to eq [user2.id, user3.id]

        expect(op.model.conversation_id).not_to be_nil
      end
    end
  end
end
