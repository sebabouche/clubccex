class Post::Cell::Grid < Cell::Concept
  include Kaminari::Cells
  include ActionView::Helpers::JavaScriptHelper

  inherit_views Post::Cell
  
  def show
    render :grid
  end

  private

  def posts
    model
  end

  def current_user
    options[:current_user]
  end

  def append
    %{ $('#next-posts').replaceWith("#{j(show)}") }
  end

  def page
    options[:page] or 1
  end

  def next_category_path
    category_path(id: options[:category_id], page: model.next_page)
  end
end

