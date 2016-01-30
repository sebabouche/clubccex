class Post::Cell < Cell::Concept
  property :title
  property :body
  property :category
  property :user

  def show
    render
  end
end
