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
        
      class Sleeping < Confirmed
        contract do
          property :sleeping, default: "1"
        end
      end
    end
  end
end
