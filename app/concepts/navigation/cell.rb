class Navigation::Cell < ::Cell::Concept
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActiveLinkTo

  def show
    render
  end

  private

  def admin?
    options[:current_user].admin?
  end

  def current_user
    options[:current_user].id
  end
  
  def email
    options[:current_user].email
  end

  def menu_item(text, link, lib = nil, icon = nil)
    active_link_to link do
      unless lib.nil? or icon.nil?
        content_tag(:span, "", class: "#{lib} #{lib}-#{icon}") +
        content_tag(:span, " #{text}")
      else
        text
      end
    end
  end

  def css_classes
    if admin?
      "navmenu-inverse admin"
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
