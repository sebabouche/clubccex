class Recommendation::Cell < Cell::Concept
  property :user
  property :recommender
  property :confirmed

  def show
    render
  end

  class Form < self
    include ActionView::RecordIdentifier
    include SimpleForm::ActionViewExtensions::FormHelper

    def show
      render :form
    end
  end
end
