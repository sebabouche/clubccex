require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #sign_up_form" do
    it "returns http success" do
      get :sign_up_form
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #sign_in_form" do
    it "returns http success" do
      get :sign_in_form
      expect(response).to have_http_status(:success)
    end
  end

end
