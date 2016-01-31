class Comment::Cell::Line < Comment::Cell
  inherit_views Comment::Cell
  def show
    render :line
  end
end
