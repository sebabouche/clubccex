class Recommendation < ActiveRecord::Base
  class Confirm < Trailblazer::Operation
    include Model
    model Recommendation, :find

    contract do
      property :confirmed

      validates :confirmed, presence: true
    end

    def process(params)
      validate(params[:recommendation]) do
        contract.save
        confirm_user!
      end
    end

    private

    def confirm_user!
    end

  end
end
