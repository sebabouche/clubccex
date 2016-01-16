class User < ActiveRecord::Base
  class Confirm < Trailblazer::Operation
    include Model
    model User, :find

    contract do
      property :confirmed, default: true
      property :sleeping, default: true
    end

    def process(params)
      contract.save
      notify_confirmed!
    end

    private

    def notify_confirmed!
      UserMailer.wake_up(model.id).deliver_now
    end
  end
end

