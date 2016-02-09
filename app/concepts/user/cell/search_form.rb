class User::Cell::SearchForm < Cell::Concept
  include ActionView::RecordIdentifier
  include SimpleForm::ActionViewExtensions::FormHelper
  include Ransack::Helpers::FormHelper

  inherit_views User::Cell

  def show
    render :search_form
  end

  private

  def users_path
    options[:url]
  end

  def erase_search
    if !model.firstname_or_lastname_or_email_or_nickname_or_occupation_or_company_cont.nil? or !model.events_number_eq.nil?
      link_to users_path, class:"btn btn-danger" do
        content_tag(:i, "", class: "fa fa-eraser")
      end
    end
  end
end
