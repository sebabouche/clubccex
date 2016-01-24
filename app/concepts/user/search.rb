class User < ActiveRecord::Base
  class Search < Trailblazer::Operation
    include Kaminari::ActiveRecordExtension

    def model!(params)
      q = User.ransack(params[:q])
      results = q.result().page(params[:page]).per(params[:per])
    end
  end
end
