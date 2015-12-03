require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response.body).to have_selector("input.email", count: 3)
      expect(response.body).to have_selector("input#user_firstname")
      expect(response.body).to have_selector("input#user_recommenders_attributes_0_firstname")
      expect(response.body).to have_selector("input#user_recommenders_attributes_1_firstname")
    end
  end

  describe "POST #create" do

    context "when valid" do
      it "redirects to thank_you_page" do
        post :create, {user: {
                  firstname: "Sébastien",
                  lastname: "Nicolaïdis",
                  email: "s.nicolaidis@me.com",
                  recommenders: [
                    {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                    {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
                  ]}}

        expect(response).to redirect_to home_thankyou_path
      end
    end
      
    context "when invalid" do
      it 'renders new' do
        post :create, {user: {firstname: ""}}

        expect(response).to render_template(:new)
        expect(response.body).to have_selector(:css, "div.alert")
        expect(response.body).to have_selector("input.email", count: 3)
      end
    end
  end
end
