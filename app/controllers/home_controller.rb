class HomeController < ApplicationController
  layout 'home'

  def index
    form User::Create
  end

  def thankyou
  end
end
