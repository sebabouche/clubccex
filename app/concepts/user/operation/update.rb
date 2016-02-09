class User < ActiveRecord::Base
  class Update < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :update?
    model User, :update

    builds -> (model, policy, params) do
      return self::ThisIsMe if policy.this_is_me?
      #return self::Admin if policy.admin?
    end

    class CurrentUser < Trailblazer::Operation
      contract Contract::ThisIsMe

      def model!(params)
        User.find(params[:current_user])
      end
    end

    class ThisIsMe < self
      contract Contract::ThisIsMe

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
          v.process!(:medium) { |job| job.thumb!("300x300#") }
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
