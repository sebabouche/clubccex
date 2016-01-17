class User::Policy
  attr_reader :model, :user

  def initialize(user, model)
    @user, @model = user, model
  end

  def signed_in?
    user.present?
  end

  def admin?
    puts model.inspect
    puts user.inspect
    signed_in? and user.admin?
  end
end
