class Comment::Cell::Form < Comment::Cell
  include ActionView::RecordIdentifier
  include SimpleForm::ActionViewExtensions::FormHelper

  inherit_views Comment::Cell

  def show
    render :form
  end

  private

  def post
    options[:post]
  end
end
