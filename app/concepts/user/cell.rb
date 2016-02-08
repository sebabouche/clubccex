class User::Cell < ::Cell::Concept
  property :gender
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
  property :facebook
  property :linkedin
  property :twitter
  property :image_meta_data

  property :events
  property :posts

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

  def profile_completion
    total = 41.0
    rating = 0.0
    rating += 1 if gender.present?
    rating += 5 if image_meta_data.present?
    rating += 5 if phone.present?
    rating += 5 if city.present?
    rating += 5 if company.present?
    rating += 5 if occupation.present?
    rating += 5 if events.count > 1
    rating += 5 if facebook.present?
    rating += 5 if linkedin.present?
    (rating / total * 100).to_i
  end

  def profile_empty?
    profile_completion == 0
  end

  def profile_completed?
    profile_completion > 70
  end
end
