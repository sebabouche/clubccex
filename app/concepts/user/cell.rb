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
  property :confirmed
  property :sleeping

  property :events

  property :recommendations

  include ActionView::Helpers::DateHelper
  property :created_at

  def show
    render
  end

  private

  def admin?
    options[:user].admin?
  end

  def user
    options[:user]
  end
end
