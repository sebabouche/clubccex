class Recommendation < ActiveRecord::Base
  class Confirm < Trailblazer::Operation
    include Model
    model Recommendation, :find

    contract do
      property :confirmed

      validates :confirmed, presence: true
    end

    include Dispatch
    callback :default, Callback::Default

    def process(params)
      validate(params[:recommendation]) do
        contract.save
        dispatch!
      end
    end

  end
end
