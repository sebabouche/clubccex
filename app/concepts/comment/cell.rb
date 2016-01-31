class Comment::Cell < Cell::Concept
  property :created_at
  property :body
  property :user

  include Clubccex::Cell::CreatedAt

  def show
    render
  end
end
