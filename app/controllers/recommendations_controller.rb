class RecommendationsController < ApplicationController
  def edit
    form Recommendation::Update
  end

  def update
   run Recommendation::Update do
     flash[:notice] = "Vous avez confirmé cette personne."
     return redirect_to root_path
   end

   render 'edit'
  end
end
