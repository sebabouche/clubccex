require 'rails_helper'

RSpec.describe Category::Create, type: :operation do
  describe "Category::Create" do
    let (:admin) { User::Create::Confirmed::Admin.(user: {
      firstname: "Admin",
      lastname: "Istrator",
      email: "admin@clubccex.com" }).model }
    let(:valid) { Category::Create.(category: {
      priority: 1,
      name: "Jobs"
    },
    current_user: admin).model }
    
    it "renders form" do
      form = Category::Create.present({current_user: admin}).contract

      expect(form.priority).to be_falsey
      expect(form.name).to be_falsey
    end

    it "with valid user infos" do
      admin

      res, op = Category::Create.run(category: {
        priority: 1,
        name: "Jobs"
      },
      current_user: admin)

      expect(op.model.persisted?).to be_truthy
      expect(op.model.priority).to eq 1
      expect(op.model.name).to eq 'Jobs'
    end
  end
end
