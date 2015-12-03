class UsersController < ApplicationController
  layout 'home'

  def new
    form User::Create
  end
  
  def create
    run User::Create do
      flash[:notice] = "Ok for it!"
      return redirect_to home_thankyou_path
    end

    @form.prepopulate!
    render 'new'
  end
end
