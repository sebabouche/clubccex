class User < ActiveRecord::Base
  class Update < Trailblazer::Operation
    include Resolver
    policy User::Policy, :update?
    model User, :update

    builds -> (model, policy, params) do
      return self::ThisIsMe if policy.this_is_me?
      return self::Admin if policy.admin?
    end
    contract do
      feature Disposable::Twin::Persisted
      require "reform/form/validation/unique_validator.rb"
    end

    class ThisIsMe < self
      contract do
        property :gender
        property :firstname
        property :lastname
        property :maidenname
        property :nickname
        property :email
        property :company
        property :occupation
        property :phone
        property :city

        property :file, virtual: true
        validates :file, 
          file_size: { less_than_or_equal_to: 3.megabytes },
          file_content_type: { allow: ['image/jpeg', 'image/png'] }
        extend Paperdragon::Model::Writer
        processable_writer :image
        property :image_meta_data, deserializer: { writeable: false }

        collection :events,
        prepopulator:      :prepopulate_events!,
        populate_if_empty: :populate_events!,
        skip_if:           :all_blank do
          property :number

          validates :number, presence: true
        end
          
        validates :firstname, :lastname, :email, presence: true
        validates :email, email: true

        private

        def prepopulate_events!(options)
          (3 - events.size).times { events.append(Event.new) }
        end

        def populate_events!(fragment:, **)
          Event.find_by(number: fragment["number"]) or Event.new
        end
      end

      include Dispatch
      callback(:upload_image) do
        on_change :upload_image!, property: :file
        
      end

      def process(params)
        validate(params[:user]) do
          dispatch!(:upload_image)
          contract.save
        end
      end

      private

      def upload_image!(user, operation:, **)
        operation.contract.image!(operation.contract.file) do |v|
          v.process!(:original)
          v.process!(:thumb) { |job| job.thumb!("120x120#") }
        end
      end
    end

    class Admin < ThisIsMe
      contract do
        property :confirmed
      end

      def process(params)
        User::Confirm.(params)
      end
    end
  end

  ImageProcessor = Struct.new(:image_meta_data) do
    extend Paperdragon::Model::Writer
    processable_writer :image
  end  
  
end
