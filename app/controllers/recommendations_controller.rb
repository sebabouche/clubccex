class RecommendationsController < LoggedController

  def index
    @collection = tyrant.current_user.pending_confirmations
  end

  def edit
    form Recommendation::Update
  end

  def update
   run Recommendation::Update do
     flash[:notice] = "Vous avez confirmé cette personne."
     return redirect_to recommendations_path
   end

   @collection = tyrant.current_user.pending_confirmations
   render 'index'
  end
end
