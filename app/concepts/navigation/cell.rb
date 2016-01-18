class Navigation::Cell < ::Cell::Concept
  property :current_user
  property :signed_in?
    
  def show
    render
  end

  private

  def admin?
    options[:current_user].admin?
  end

  def css_classes
    if admin?
      "navmenu-default"
    else
      "navmenu-inverse"
    end
  end

  def title
    title = "Club CCEx"
    title += " [admin]" if admin?
    title
  end

end
