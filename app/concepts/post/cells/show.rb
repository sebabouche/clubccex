class Post::Cell::Show < Post::Cell
  inherit_views Post::Cell

  def show
    render :show
  end
end
