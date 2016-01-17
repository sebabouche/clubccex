class User < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model User, :create

    contract do
      property :email
      property :firstname
      property :lastname
      property :confirmed, default: "0"
      property :sleeping, default: "0"

      validates :email, :firstname, :lastname, presence: true
      validates :email, email: true
    end

    def process(params)
      validate(params[:user]) do
        contract.save
      end
    end
    
    class Unconfirmed < Create

      class Sleeping < Unconfirmed
        contract do
          property :sleeping, default: "1"
        end
      end
    end

    class Confirmed < Create
      # TODO Add Tyrant to confirmed
      contract do
        property :confirmed, default: "1"
      end

      def process(params)
        validate(params[:user]) do
          confirm!
          contract.save
        end
      end

      private

      def confirm!
        auth = Tyrant::Authenticatable.new(contract.model)
        auth.digest!("password")
        auth.confirmed!
        auth.sync
        contract.save
      end
        
      class Sleeping < Confirmed
        contract do
          property :sleeping, default: "1"
        end

        def process(params)
          validate(params[:user]) do
            confirmable!
            contract.save
          end
        end

        private

        def confirmable!
          auth = Tyrant::Authenticatable.new(contract.model)
          auth.confirmable!
          auth.sync
          contract.save
        end
      end

      class Admin < Confirmed
        contract do
          property :admin, default: true
        end
      end
    end
  end
end
