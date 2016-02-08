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
    options[:current_user]
  end

  def this_is_mine?
    user == current_user
  end

  def link_title
    link_to post_path(model), class: title_class do
      content_tag(:i, "", 
                  class: title_icon_class, 
                  data: {toggle: "tooltip", placement: "auto"}, 
                  title: title_tooltip) +
      content_tag(:span, title)
    end
  end

  def title_class
    if model.closed?
      "text-muted"
    end
  end

  def title_icon_class
    if model.closed?
      "fa fa-check-circle"
    else
      "fa fa-exclamation-circle"
    end
  end

  def title_tooltip
    if model.closed?
      "Ce post été résolu"
    else
      "Ce post attend encore une réponse"
    end
  end

  def edit_link
    if this_is_mine?
      content_tag :small do
        link_to "(modifier)", edit_post_path(model)
      end
    end
  end

end
