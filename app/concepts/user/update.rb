class User < ActiveRecord::Base
  class Update < Trailblazer::Operation
    include Resolver
    policy User::Policy, :update?
    model User, :update

    builds -> (model, policy, params) do
      return self::ThisIsMe if policy.this_is_me?
      return self::Admin if policy.admin?
    end

    class ThisIsMe < self
      contract do
        property :firstname
        property :lastname
        property :email
      end
    end

    class Admin < ThisIsMe
      contract do
        property :confirmed
      end

      def process(params)
        User::Confirm.(params)
      end
    end
  end
end
    

