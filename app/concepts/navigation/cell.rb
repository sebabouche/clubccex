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

  def menu_item(text, link, lib = nil, icon = nil, exclusive = false)
    if exclusive == true
      active_link_to link, active: :exclusive do
        unless lib.nil? or icon.nil?
          content_tag(:span, "", class: "#{lib} #{lib}-#{icon}") +
          content_tag(:span, " #{text}")
        else
          text
        end
      end
    else
      active_link_to link do
        unless lib.nil? or icon.nil?
          content_tag(:span, "", class: "#{lib} #{lib}-#{icon}") +
          content_tag(:span, " #{text}")
        else
          text
        end
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
    "<li><a href='#{recommendations_path}' class='text-warning'><span class='fa fa-exclamation-triangle'></span> #{pluralize(pending_confirmation_count, 'confirmation')} en attente</a></li> " if pending_confirmations?
  end

  def pending_confirmations?
    options[:current_user].pending_confirmations.present?
  end

  def pending_confirmation_count
    options[:current_user].pending_confirmations.size
  end

  def toggle_nav_button
    "<button class='btn btn-nav btn-togglenav' id='togglenav' type='button' data-toggle='offcanvas' data-target='#navMenu' data-canvas='body' role='navigation'></button>"
  end

  def new_post_button
    "<button class='btn btn-nav btn-newpost' type='button' role='new post' data-toggle='modal' data-target='#newPostModal'></button>"
  end
end
