class Post < ActiveRecord::Base
  class Index < Trailblazer::Operation
    def model!(params)
      Post.from_category(params[:id]).page(params[:page]).per(24)
    end
  end
end
