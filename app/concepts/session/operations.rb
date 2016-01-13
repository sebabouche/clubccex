module Session
  class SignUp < Trailblazer::Operation
    include Model
    model User, :create

    contract do
      property :email
      property :firstname
      property :lastname

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
        update_user_confirmation!(contract)

        contract.save
        
        dispatch!(:after_save)
      end
    end

    callback(:after_save) do
      if model.confirmed == 1
        UserMailer.confirm_sleeping(model.id)
      else
        UserMailer.awaiting_confirmation(model.id)
      end

      collection :recommenders do
        on_add :notify_recommender!
        def notify_recommender!(recommender, **)
          if recommender.confirmed == 0 and recommender.sleeping == 1
            UserMailer.sign_up_unconfirmed_sleeping(recommender.id)
          elsif recommender.confirmed == 0 and recommender.sleeping == 1
            UserMailer.sign_up_reminder(user.id)
          elsif recommender.confirmed == 1
            UserMailer.confirm_user(user.id)
          end
        end
      end
    end
    
    private

    def update_user_confirmation!(contract)
      if contract.recommenders[0].model.confirmed == 1 and contract.recommenders[1].model.confirmed == 1
        contract.model.confirmed = 1
        contract.model.sleeping = 1
      else
        contract.model.confirmed = 0
        contract.model.sleeping = 0
      end
    end

    def do_not_update_recommender!(recommender, options)
      return if !recommender.persisted?

      recommender.firstname = recommender.model.firstname
      recommender.lastname = recommender.model.lastname
      recommender.email = recommender.model.email
      recommender.sync
    end

  end
end 
