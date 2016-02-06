class User::Cell::Card < User::Cell
  inherit_views User::Cell

  def show
    render :card
  end

  private

  def css_classes
    "col-md-4 col-sm-6 card profile profile-card"
  end

  def recommendations
    if model.recommendations.present?
      reco = "Demande de recommandation à "
      model.recommendations.each_with_index do |recommendation, index|
        reco += link_to recommendation.recommender.firstname + " " + recommendation.recommender.lastname, user_path(recommendation.recommender)
        reco += ", " if index < model.recommendations.size - 1
      end
    end
    reco
  end

  def user_status
    case [model.confirmed, model.sleeping]
    when [1, 0]
      "<span class='label label-success' data-toggle='tooltip' title='Enregistré'><i class='fa fa-check'></i></span>"
    when [1, 1]
      "<span class='label label-info' data-toggle='tooltip' title='Doit créer son mot de passe'><i class='fa fa-unlock'></i></span>"
    when [0, 0]
      "<span class='label label-warning' data-toggle='tooltip' title='En attente de confirmation'><i class='fa fa-clock-o'></i></span>"
    when [0, 1]
      "<span class='label label-danger' data-toggle='tooltip' title='Relancer / Vérifier email'><i class='fa fa-question'></i></span>"
    end
  end
end
