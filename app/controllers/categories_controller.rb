class CategoriesController < LoggedController

  def index
    @categories = Category.order(:priority)
    form Category::Create
  end

  def show
    # raise params.inspect
    collection Post::Index

    respond_to do |format|
      format.html { render }
      format.js { render js: concept("post/cell/grid", @collection, category_id: params[:id], page: params[:page], user: tyrant.current_user).(:append) }
    end
  end

  def create
    run Category::Create do |op|
      flash[:notice] = "Catégorie créée."
      return redirect_to categories_path
    end

    render :new
  end

  def edit
    form Category::Update
  end

  def update
    run Category::Update do |op|
      flash[:notice] = "Catégorie modifiée."
      return redirect_to categories_path
    end
  end
end
