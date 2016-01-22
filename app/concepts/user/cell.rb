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

  include ActionView::Helpers::DateHelper
  property :created_at

  def show
    render
  end

  private

  def fullname
    firstname + " " + lastname
  end
  
  def created_at
    "Membre du Club depuis " + time_ago_in_words(super)
  end
end
