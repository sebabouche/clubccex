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
      validate(params[:comment]) do
        contract.user_id = params[:current_user].id
        contract.save
        notify_author!
      end
    end

    def post
      model.post
    end

    private

    def notify_author!
      UserMailer.notify_comment(contract.id) if contract.post.user.id != contract.user_id
    end

    def setup_model!(params)
      model.post = Post.find_by_id(params[:id])
    end
  end
end
