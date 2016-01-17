class HomeController < ApplicationController
  def index
    if tyrant.signed_in?
      redirect_to logged_index_path
    else
      redirect_to sessions_sign_up_form_path
    end
  end
end
