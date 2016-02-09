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
      property :closed, default: "false"
      property :category, 
      prepopulator: -> (*) { self.category = Category.new }, 
      populator: :populate_category! do
        property :id

        validates :id, presence: true
      end

      property :user_id

      validates :title, :body, :category, presence: true
      validates :title, length: {in: 4..140}
      
      private

      def populate_category!(fragment:, **)
        self.category = Category.find(fragment["id"])
      end
        
    end

    def process(params)
      validate(params[:post]) do
        contract.user_id = params[:current_user].id
        contract.save
      end
    end
  end
end
