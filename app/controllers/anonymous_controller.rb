class AnonymousController < ApplicationController
  layout 'anonymous'

  def index
    form User::Create
  end

  def thankyou
  end

end
