class Recommendation < ActiveRecord::Base
  class Update < Trailblazer::Operation
    include Model
    model Recommendation, :find

    contract do
      property :confirmed
      property :user
      property :recommender

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
      user = User.find(model.user.id)
      return if user.recommendations.find_all { |r| r.confirmed? }.size < 2
      User::Confirm.(id: user.id)
    end
  end
end
