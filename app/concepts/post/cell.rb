class Post::Cell < Cell::Concept
  property :title
  property :body
  property :category
  property :user
  property :closed

  def show
    render
  end

  private

  def current_user
    options[:user]
  end

  def this_is_mine?
    user == current_user
  end

  def link_title
    link_to title, post_path(model)
  end

  def edit_link
    if this_is_mine?
      content_tag :small do
        link_to "(modifier)", edit_post_path(model)
      end
    end
  end

end
