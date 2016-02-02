require 'rails_helper'

RSpec.describe Comment::Create, type: :operation do
  context "valid" do
    it "renders form"
    it "persists valid"
  end

  context "invalid" do
    it "raises error if not signed in"
    it "needs a body"
  end

  context "notification" do
    it "sends notification"
    it "doesn't send notification if commenter is post writer"
  end
end

