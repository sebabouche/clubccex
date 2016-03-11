class Conversation < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Conversation

    contract do
      collection :users, populate_if_empty: :populate_user!

      private

      def populate_user!
      end

    end


    def process(params)
    end
  end
end
