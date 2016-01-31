module Session
  class WakeUp < Trailblazer::Operation
    include Model
    model User, :find

    contract do
      property :firstname
      property :lastname
      property :password, virtual: true
      property :confirm_password, virtual: true
      validates :password, :confirm_password, presence: true
      validate :password_ok?

      private

      def password_ok?
        return unless password and confirm_password
        errors.add(:password, "Password mismatch") if password != confirm_password
      end
    end

    def process(params)
      validate(params[:user]) do
        wake_up!
      end
    end

    attr_reader :confirmation_token

    private

    def wake_up!
      auth = Tyrant::Authenticatable.new(contract.model)
      auth.digest!(contract.password)
      auth.confirmed!
      auth.sync
      contract.save
    end

    def setup_params!(params)
      @confirmation_token = params[:confirmation_token]
    end
  end
end
