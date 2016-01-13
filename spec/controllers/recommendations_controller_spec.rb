require 'rails_helper'

RSpec.describe RecommendationsController, type: :controller do

  describe "GET #edit" do
    it "returns http success" do
      recommendation = Recommendation.create
      get :edit, id: recommendation.id
      expect(response).to have_http_status(:success)
    end
  end

end
