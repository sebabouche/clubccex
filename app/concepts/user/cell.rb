class User::Cell < ::Cell::Concept
  property :email
  property :firstname
  property :lastname
  property :maidenname
  property :nickname
  property :company
  property :occupation
  property :phone
  property :city

  property :events

  include ActionView::Helpers::DateHelper
  property :created_at

  def show
    render
  end

  private

  def user
    options[:user]
  end
end
