class User < ActiveRecord::Base
  class Create < Trailblazer::Operation
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
      end

      validates :email, :firstname, :lastname, presence: true
      validates :email, email: true
      validate :not_enough_recommenders

      private 

      def not_enough_recommenders
        return if recommenders.size >= 2
        errors.add(:user, "Vous devez spécifier deux recommandations")
      end

      def prepopulate_recommenders!(options)
        (2 - recommenders.size).times { recommenders << User.new }
      end

      def populate_recommenders!(params, options)
        User.where("(firstname = ? and lastname = ?) or email = ?", 
                   params["firstname"], 
                   params["lastname"],
                   params["email"]).first or User.new
      end

    end

    include Dispatch
    callback(:before_save) do
      collection :recommenders do
        on_change :do_not_update_recommender!
      end
    end

    def process(params)
      validate(params[:user]) do |f|
        dispatch!(:before_save)
        f.save
      end
    end
    
    private

    def do_not_update_recommender!(recommender)
      return if !recommender.persisted?

      recommender.firstname = recommender.model.firstname
      recommender.lastname = recommender.model.lastname
      recommender.email = recommender.model.email
      recommender.sync
    end
  end
end
