class UsersController < LoggedController
  def index
  end

  def show
    present User::Show
  end
end
