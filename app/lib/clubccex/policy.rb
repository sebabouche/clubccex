module Clubccex
  class Policy

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
      signed_in? and this_is_me?
    end

    def this_is_me?
      user == model
    end

    def admin_or_this_is_me?
      admin? or this_is_me?
    end

    def admin_or_recommender?
      admin? or recommender?
    end

    def recommender?
      model.recommender == user
    end
  end
end
