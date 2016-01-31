class Comment::Cell::Grid < Cell::Concept
  inherit_views Comment::Cell
  
  include Kaminari::Cells
  include ActionView::Helpers::JavaScriptHelper

  def show
    render :grid
  end

  def append
    %{ $('#next').replaceWith("#{j(show)}") }
  end

  private

  def comments
    @comments ||= model.comments.page(page).per(3)
  end

  def page
    options[:page] or 1
  end
end
