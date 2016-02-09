class User < ActiveRecord::Base
  class Confirm < Trailblazer::Operation
    include Model
    model User, :find

    contract do
      property :confirmed
      property :sleeping
    end

    def process(params)
      set_confirmable!
      set_confirmed_sleeping!
      contract.save
      notify_confirmed!
    end

    private

    def notify_confirmed!
      UserMailer.wake_up(model.id).deliver_now
    end

    def set_confirmable!
      auth = Tyrant::Authenticatable.new(contract.model)
      auth.confirmable!
      auth.sync
    end

    def set_confirmed_sleeping!
      contract.confirmed = 1
      contract.sleeping = 1
      contract.sync
    end

    class Admin < Confirm
      include Resolver
      policy Clubccex::Policy, :admin?
      model User, :find
    end
  end
end

