class User < ActiveRecord::Base
  class Show < Trailblazer::Operation
    include Model
    model User, :find

  end
end
