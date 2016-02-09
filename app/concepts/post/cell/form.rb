class Post::Cell::Form < Post::Cell
  include ActionView::RecordIdentifier
  include SimpleForm::ActionViewExtensions::FormHelper

  inherit_views Post::Cell

  def show
    render :form
  end
end
