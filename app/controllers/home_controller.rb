class HomeController < ApplicationController

  def index
    if tyrant.signed_in?
      redirect_to bienvenue_path
    else
      redirect_to inscription_path
    end
  end

end
