class Post < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :signed_in?
    model Post, :create

    contract do
      include Reform::Form::ActiveModel::ModelReflections
      feature Disposable::Twin::Persisted

      property :title
      property :body
      property :category_id
      property :user_id

      validates :title, :body, :category_id, presence: true
    end

    def process(params)
      validate(params[:post]) do
        contract.user_id = params[:current_user].id
        contract.save
      end
    end
  end
end
