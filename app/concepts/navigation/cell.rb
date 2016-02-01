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

  def categories
    categories = ""
    Category.all.each do |category|
      category_link = content_tag :li do
        active_link_to category_path(category) do
          content_tag(:span, "", class: "#{category.library} #{category.library}-#{category.icon}") +
          content_tag(:span, " " + category.name)
        end
      end
      categories += category_link
    end
    categories
  end

  def pending_confirmations
    "<li class='text-danger'><a href='#{recommendations_path}'><span class='fa fa-exclamation-triangle'></span> Confirmations en attente (#{pending_confirmation_count})</a></li> " if pending_confirmations?
  end

  def pending_confirmations?
    options[:current_user].pending_confirmations.present?
  end

  def pending_confirmation_count
    options[:current_user].pending_confirmations.size
  end
end
