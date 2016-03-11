class Conversation < ActiveRecord::Base
  class Create
    include Model
    model Conversation

    contract do
      collection :users, populate_if_empty: :populate_user!

      private

      def populate_user!

    end


    def process(params)
    end
  end
end
