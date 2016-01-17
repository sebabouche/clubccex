module Session
  class IsSignUpable < Trailblazer::Operation
    include Model
    model User, :find

    def process(params)
      return if model.confirmed == 0 and model.sleeping == 1
      invalid!
    end
  end
end
