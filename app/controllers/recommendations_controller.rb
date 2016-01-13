class RecommendationsController < ApplicationController
  def edit
    form Recommendation::Confirm
  end

  def update
   run Recommendation::Confirm do
     flash[:notice] = "Vous avez confirmé cette personne."
     return redirect_to root_path
   end

   render 'edit'
  end
end
