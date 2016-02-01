class User < ActiveRecord::Base
  class Search < Trailblazer::Operation
    include Policy
    policy Clubccex::Policy, :signed_in?
    
    include Kaminari::ActiveRecordExtension

    def model!(params)
      q = users.confirmed.ransack(params[:q])
      results = q.result().page(params[:page]).per(params[:per])
    end

    def users
      User.confirmed
    end

    class Unconfirmed < self
      def users
        User.unconfirmed
      end
    end

    class All < self
      def users
        User.all
      end
    end
  end
end
