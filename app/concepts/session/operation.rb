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
        User.find_by_email(fragment["email"]) or User.new
      end
    end

    include Dispatch
    callback(:before_save) do
      collection :recommenders do
        on_change :do_not_update_recommender!
      end

      # si les deux recommenders sont confirmés, user est confirmé
      # TODO update_user_confirmation!
    end


    def process(params)
      validate(params[:user]) do
        dispatch!(:before_save)
        contract.save
        dispatch!(:after_save)
      end
    end

    callback(:after_save) do
      # si user est confirmé, envoie sleeping_user sinon envoie waiting_list
      # TODO notify_user!

      collection :recommenders do
        # si recommender sleeping_waiting, envoie confirm_yourself
        # si recommender confirmed_waiting, rien
        # si recommender sleeping_user, envoie "Reminder, créez votre compte"
        # si recommender confirmed_user, envoie confirm_waiting
        # TODO on_create :notify_sleeping_waiting!
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
  end
end 
