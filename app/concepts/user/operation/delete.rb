class User < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    include Resolver
    policy Clubccex::Policy, :admin?
    model User, :find

    contract Contract::ThisIsMe

    def process(params)
      model.destroy
      delete_image!
    end

    private

    def delete_image!
      User::ImagePreprocessor.new(model.image_meta_data).image! { |v| v.delete }
    end
  end
end
