class UsersController < LoggedController
  def index
    @q  = User.ransack(params[:q])
    collection User::Search
  end

  def next
    collection User::Search

    render js: concept("user/cell/grid", @collection, page: params[:page], user: tyrant.current_user).(:append)
  end

  def unconfirmed
    @q  = User.ransack(params[:q])
    collection User::Search::Unconfirmed

    render :index
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
      return redirect_to user_path(op.model)
    end

    render :edit
  end

  def confirm
    run User::Confirm do |op|
      flash[:notice] = "#{op.model.firstname} est confirmé!"
      return redirect_to users_path
    end
  end
end
