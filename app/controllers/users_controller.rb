class UsersController < LoggedController
  def index
  end

  def unconfirmed
  end

  def show
    present User::Show
  end

  def edit
    form User::Update
  end

  def update
    run User::Update do |op|
      flash[:notice] = "Le compte a bien été mis à jour"
      return redirect_to users_path
    end

    render :edit
  end
end
