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
        property :maidenname
        property :nickname
        property :email
        property :company
        property :occupation
        property :phone
        property :city

        collection :events, 
        prepopulator: :prepopulate_events!,
        populator: :populate_events!,
        skip_if: :all_blank do
          property :number

          validates :number, presence: true
        end
          
        validates :firstname, :lastname, :email, presence: true
        validates :email, email: true

        private

        def prepopulate_events!(options)
          (3 - events.size).times { events.append(Event.new) }
          raise events.size.inspect
        end

        def populate_events!(fragment:, **)
          Event.find_by(number: fragment["number"]) or Event.new
        end
      end

      def process(params)
        validates(params[:user]) do
          raise contract.inspect
        end
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
