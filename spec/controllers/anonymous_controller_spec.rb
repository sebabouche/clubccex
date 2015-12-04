require 'rails_helper'

RSpec.describe AnonymousController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns http success shows form" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "shows user form" do
      get :index
      expect(response.body).to have_selector("input.email", count: 3)
      expect(response.body).to have_selector("input#user_firstname")
      expect(response.body).to have_selector("input#user_recommenders_attributes_0_firstname")
      expect(response.body).to have_selector("input#user_recommenders_attributes_1_firstname")

    end
  end


  describe "GET #thankyou" do
    it "returns http success and thanks" do
      get :thankyou
      expect(response).to have_http_status(:success)
    end

    it "says thankyou (in French)" do
      get :thankyou
      expect(response.body).to match "Merci !"
    end
  end
end
