class Message < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :signed_in?
    model Message

    contract do
      property :body
      property :user

      property :conversation,
      prepopulator: -> (*) { self.conversation = Conversation.new },
      populate_if_empty: -> (*) { Conversation.new }

      collection :users,
      prepopulator: :prepopulate_users!,
      populate_if_empty: :populate_user! do
        property :email

        validates :email, presence: true
      end

      private

      def prepopulate_users!(options)
        (2 - users.size).times { users << User.new }
      end

      def populate_user!(fragment:, **)
        User.find_by_email(fragment["email"])
      end
    end

    def process(params)
      validate(params[:message]) do
        ap contract, index: false
        contract.user = params[:current_user]
        contract.save
      end
    end

    private

    def create_conversation!
    end

  end
end
