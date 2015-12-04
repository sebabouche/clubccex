class UsersController < AnonymousController
  def new
    form User::Create
  end
  
  def create
    run User::Create do
      flash[:notice] = "Ok for it!"
      return redirect_to merci_path
    end

    @form.prepopulate!
    render 'new'
  end
end
