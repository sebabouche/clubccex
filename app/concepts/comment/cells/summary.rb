class Comment::Cell::Summary < Cell::Concept
  inherit_views Comment::Cell

  def show
    render :summary
  end

  private

  def comments
    @comments ||= model.comments.take(3)
  end
end
