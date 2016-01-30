class User::Cell::Card < User::Cell
  inherit_views User::Cell

  def show
    render :card
  end

  private

  def css_classes
    "col-md-4 col-sm-6 profile profile-card"
  end
end
