class User < ActiveRecord::Base
  class Show < Trailblazer::Operation
    include Model
    model User, :find

    class CurrentUser < Trailblazer::Operation
      def model!(params)
        User.find(params[:current_user])
      end
    end
  end
end
