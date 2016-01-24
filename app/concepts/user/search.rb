class User < ActiveRecord::Base
  class Search < Trailblazer::Operation
    include Kaminari::ActiveRecordExtension

    def model!(params)
      q = users.ransack(params[:q])
      results = q.result().page(params[:page]).per(params[:per])
    end

    def users
      User.all
    end

    class Unconfirmed < self
      def users
        User.unconfirmed
      end
    end
  end
end
