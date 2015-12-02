class UsersController < ApplicationController
  def new
    form User::Create
  end
  
  def create
    run User::Create do
      flash[:notice] = "Ok for it!"
      return redirect_to home_thank_you_path
    end

    render 'new'
  end
end
