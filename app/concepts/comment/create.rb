class Comment < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :signed_in?
    model Comment, :create

    contract do
      include Reform::Form::ActiveModel::ModelReflections
      
      property :body
      property :post
      property :user_id

      validates :body, length: { in: 6..160 }
      validates :body, :post, presence: true
    end

    def process(params)
      validate(params[:comment]) do |f|
        contract.user_id = params[:current_user].id
        f.save
      end
    end

    def post
      model.post
    end

    private

    def setup_model!(params)
      model.post = Post.find_by_id(params[:id])
    end
  end
end
