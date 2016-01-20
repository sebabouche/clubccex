class User::Policy
  attr_reader :model, :user

  def initialize(user, model)
    @user, @model = user, model
  end

  def signed_in?
    user.present?
  end

  def admin?
    signed_in? and user.admin?
  end

  def update?
    signed_in? and (admin? or this_is_me?)
  end

  def this_is_me?
    user == model
  end
end
