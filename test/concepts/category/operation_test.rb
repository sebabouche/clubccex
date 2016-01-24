require 'test_helper'

class CategoryOperationTest < MiniTest::Spec
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

      form.priority.must_equal nil
      form.name.must_equal nil
    end

    it "with valid user infos" do
      admin

      res, op = Category::Create.run(category: {
        priority: 1,
        name: "Jobs"
      },
      current_user: admin)

      op.model.persisted?.must_equal true
      op.model.priority.must_equal 1
      op.model.name.must_equal 'Jobs'
    end
  end
end
