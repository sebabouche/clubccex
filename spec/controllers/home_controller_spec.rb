require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views

  describe "GET #index" do
    it "when not logged in redirects to anonymous#index" do
      pending "Problem with tyrant.signed_in?"
      get :index
      expect(response).to redirect_to inscription_path
    end

    it "when logged in redirects to logged#welcome" do
      pending "Problem with tyrant.signed_in?"
      tyrant = Tyrant::Session.new(request.env['warden'])
      Session::SignUp.(user: {email: "s.nicolaidis@me.com", password: "123123", confirm_password: "123123"})
      visit '/sessions/sign_in_form'
      fill_in "session[email]", with: "s.nicolaidis@me.com"
      fill_in "session[password]", with: "123123"
      click_button "Se connecter"

      expect(response).to redirect_to bienvenue_path
    end
  end
end
