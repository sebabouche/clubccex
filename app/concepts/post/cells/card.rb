class Post::Cell::Card < Post::Cell
  inherit_views Post::Cell
  
  property :created_at
  include Clubccex::Cell::CreatedAt

  def show
    render :card
  end

  private

  def link_title
    link_to title, post_path(model)
  end
end

