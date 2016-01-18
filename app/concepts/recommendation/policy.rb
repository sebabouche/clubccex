class Recommendation::Policy
  attr_reader :model, :user

  def initialize(user, model)
    @user, @model = user, model
  end

  def signed_in?
    user.present?
  end

  def admin?
    user.admin?
  end

  def update?
    signed_in? and (admin? or model.recommender == user)
  end
end
