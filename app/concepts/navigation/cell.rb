class Navigation::Cell < ::Cell::Concept
  include ActionView::Helpers::UrlHelper
  include ActiveLinkTo

  property :current_user
  property :signed_in?
    
  def show
    render
  end

  private

  def admin?
    options[:current_user].admin?
  end

  def menu_item(text, link)
    active_link_to text, link
  end

  def css_classes
    if admin?
      "navmenu-inverse"
    else
      "navmenu-default"
    end
  end

  def title
    title = "Club CCEx"
    title += " [admin]" if admin?
    title
  end

end
