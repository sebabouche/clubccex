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

  def current_user
    options[:current_user]
  end

  def admin?
    current_user.admin?
  end

  def this_is_me?
    model == current_user
  end

  def edit_link
    if this_is_me?
      content_tag :small do
        link_to "(modifier)", edit_profile_path
      end
    end
  end
end
