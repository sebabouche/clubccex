class Category < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :admin?
    model Category, :create

    contract do
      property :name
      property :priority
      property :icon
      property :library

      validates :name, :priority, presence: true
    end

    def process(params)
      validate(params[:category]) do
        contract.save
      end
    end
  end
end
