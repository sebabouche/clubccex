class Category < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :admin?
    model Category, :create

    contract do
      require "reform/form/validation/unique_validator.rb"

      property :priority
      property :name

      validates :priority, :name, presence: true
      validates :name, unique: true
    end

    def process(params)
      validate(params[:category]) do
        contract.save
      end
    end
  end

  class Update < Create
  end
end
