module Session
  class SignIn < Trailblazer::Operation
    contract do
      undef :persisted? # TODO: allow with trailblazer/reform.
      attr_reader :user

      property :email, virtual: true
      property :password, virtual: true
      validates :email, :password, presence: true
      validate :password_ok?

      private

      def password_ok?
        return if email.blank? or password.blank?
        @user = User.find_by(email: email)
        errors.add("Passord", "Wrong password.") unless @user and Tyrant::Authenticatable.new(@user).digest?(password)
      end
    end

    def process(params)
      validate(params[:session]) do |contract|
        @model = contract.user
      end
    end
  end
end
