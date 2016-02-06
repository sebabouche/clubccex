class User < ActiveRecord::Base
  class Search < Trailblazer::Operation
    include Policy
    policy Clubccex::Policy, :signed_in?
    
    include Kaminari::ActiveRecordExtension

    def model!(params)
      if params[:action] == "unconfirmed"
        users = User.unconfirmed
      else
        users = User.confirmed
      end

      q = users.ransack(params[:q])
      results = q.result().page(params[:page]).per(params[:per])
    end

    private

    #def users
    #  User.confirmed
    #end

    class Unconfirmed < self
      private

      def users
        User.unconfirmed
      end
    end

    class All < self
      private

      def users
        User.all
      end
    end
  end
end
