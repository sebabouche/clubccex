class User < ActiveRecord::Base
  class Adminate < Trailblazer::Operation
    include Model
    # include Resolver
    # policy Clubccex::Policy, :admin?
    model User, :update

    def process(params)
    end
  end
end
