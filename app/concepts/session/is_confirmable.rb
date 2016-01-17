module Session
  class IsConfirmable < Trailblazer::Operation
    include Model
    model User, :find

    def process(params)
      return if Tyrant::Authenticatable.new(model).confirmable?(params[:confirmation_token])
      invalid!
    end
  end
end  
