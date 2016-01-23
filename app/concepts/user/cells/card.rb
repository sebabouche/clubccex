class User::Cell::Card < User::Cell
  inherit_views User::Cell

  def show
    render :card
  end

  private

  def css_classes
    "col-md-4 col-sm-6 profile profile-card"
  end

  def confirm_button
    link_to "Confirmer cet utilisateur", 
      confirm_user_path(@model), 
      class: "btn btn-success btn-xs" if unconfirmed?
  end
end
