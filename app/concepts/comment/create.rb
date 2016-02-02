class Comment < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :signed_in?
    model Comment, :create

    contract do
      include Reform::Form::ActiveModel::ModelReflections
      
      property :body
      property :post

      validates :body, length: { in: 6..160 }
      validates :body, :post, presence: true
    end

    def process(params)
      validate(params[:comment]) do
        contract.save
        notify_author!(contract.model)
      end
    end

    def post
      model.post
    end

    private

    def notify_author!(model)
      UserMailer.notify_comment(model.id).deliver_now! if model.post.user.id != model.user.id
    end

    def setup_model!(params)
      model.user = User.find(params[:current_user].id)
      model.post = Post.find_by_id(params[:id])
    end
  end
end
