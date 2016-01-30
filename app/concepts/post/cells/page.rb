class Post::Cell::Page < Post::Cell
  inherit_views Post::Cell

  def show
    render :page
  end
end
