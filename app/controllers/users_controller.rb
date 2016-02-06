class UsersController < LoggedController
  def index
    @q  = User.ransack(params[:q])
    collection User::Search
    
    respond_to do |format|
      format.html { render }
      format.js { render js: concept("user/cell/grid", @collection, page: params[:page], user: tyrant.current_user).(:append) }
    end
  end

  def unconfirmed
    @q  = User.ransack(params[:q])
    collection User::Search

    respond_to do |format|
      format.html { render }
      format.js { render js: concept("user/cell/grid", @collection, page: params[:page], user: tyrant.current_user, unconfirmed: true).(:append) }
    end
  end

  def next_unconfirmed
    @q = User.ransack(params[:q])
    collection User::Search::Unconfirmed

    render js: concept("user/cell/grid", @collection, page: params[:page], user: tyrant.current_user).(:append)
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
