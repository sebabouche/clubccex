class User::Cell::Card < User::Cell
  inherit_views User::Cell

  def show
    render :card
  end

  private

  def css_classes
    "col-md-4 col-sm-6"
  end

  class Admin < Card
    def show
      render :admin_card
    end
  end
end
