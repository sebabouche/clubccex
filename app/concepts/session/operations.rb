module Session
  class SignUp < Trailblazer::Operation
    include Model
    model User, :create

    contract do
      feature Disposable::Twin::Persisted

      property :email
      property :firstname
      property :lastname
      property :confirmed, writeable: false

      collection :recommenders,
      prepopulator:      :prepopulate_recommenders!,
      populate_if_empty: :populate_recommenders!,
      skip_if:           :all_blank do

        property :firstname
        property :lastname
        property :email

        validates :firstname, :lastname, :email, presence: true
        validates :email, email: true
        # validates :email, unique: true
      end

      validates :email, :firstname, :lastname, presence: true
      validates :email, email: true
      validate :distinct_recommenders

      private 

      def not_enough_recommenders
        return if recommenders.size >= 2
        errors.add(:user, "Vous devez spécifier deux recommandations")
      end

      def distinct_recommenders
        return if recommenders.map(&:email).uniq.size == 2 
        errors.add(:user, "Vous devez spécifier deux recommandations différentes")
      end

      def prepopulate_recommenders!(options)
        (2 - recommenders.size).times { recommenders << User.new }
      end

      def populate_recommenders!(fragment:, **)
        User.find_by_email(fragment["email"]) or User.new(confirmed: 0, sleeping: 1)
      end
    end

    include Dispatch
    callback(:before_save) do
      collection :recommenders do
        on_change :do_not_update_recommender!
      end
    end


    def process(params)
      validate(params[:user]) do
        dispatch!(:before_save)

        contract.save
        
        dispatch!(:after_save)
      end
    end

    callback(:after_save) do
      on_create :notify_user!

      collection :recommenders do
        on_add :notify_recommender!
      end

    end
    
    private

    def do_not_update_recommender!(recommender, options)
      return if !recommender.persisted?

      recommender.firstname = recommender.model.firstname
      recommender.lastname = recommender.model.lastname
      recommender.email = recommender.model.email
      recommender.sync
    end

    def notify_user!(user, operation:, **)
      # UserMailer.welcome_unconfirmed(user.id)
      return
    end

    def notify_recommender!(recommender, operation:, **)
      # if recomm.confirmed == 0 and recomm.sleeping == 1
      #   UserMailer.sign_up(recomm.id)
      # elsif recomm.confirmed == 1 and recomm.sleeping == 1
      #   UserMailer.sign_up_reminder(recomm.id)
      # elsif recomm.confirmed == 1 and recomm.sleeping == 0
      #   UserMailer.confirm_user(recomm.id)
      # end
      return
    end
  end
end 
