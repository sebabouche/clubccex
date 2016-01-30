class PostsController < LoggedController
  def new
    form Post::Create
  end

  def create
    run Post::Create do |op|
      flash[:notice] = "Post créé!"
      return redirect_to category_path(op.model.category)
    end

    render :new
  end
end
